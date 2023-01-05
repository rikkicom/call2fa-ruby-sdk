require 'rikkicom/call2fa/version'

require 'json'

require 'faraday'

module Rikkicom
  module Call2FA
    class ClientError < StandardError
    end

    class Client
      def initialize(login, password)
        if login.length == 0
          raise ArgumentError.new('the login parameter is empty')
        end

        if password.length == 0
          raise ArgumentError.new('the password parameter is empty')
        end

        # The API version
        @version = 'v1'
        # The base URL of the API
        @baseURI = 'https://api-call2fa.rikkicom.io'

        @apiLogin = login
        @apiPassword = password

        @httpClient = Faraday.new(
          url: @baseURI,
          headers: {'Content-Type' => 'application/json'}
        )

        receiveJWT()
      end

      def receiveJWT()
        uri = makeFullURI('auth')

        response = @httpClient.post(uri) do |req|
          req.body = {login: @apiLogin, password: @apiPassword}.to_json
        end

        if response.status == 200
          data = JSON.parse(response.body)
          
          @jwt = data['jwt']
        else
          raise RuntimeError.new(sprintf('Incorrect status code: %d on authorization step', response.status))
        end
      end

      def call(phoneNumber, callbackURL = '')
        if phoneNumber.length == 0
          raise ArgumentError.new('the phoneNumber parameter is empty')
        end

        headers = {'Authorization': sprintf('Bearer %s', @jwt)}

        uri = makeFullURI('call')

        response = @httpClient.post(uri) do |req|
          req.headers = headers
          req.body = {
            'phone_number': phoneNumber,
            'callback_url': callbackURL,
          }.to_json
        end

        if response.status != 201
          raise RuntimeError.new(sprintf('Incorrect status code: %d on call step', response.status))
        end

        data = JSON.parse(response.body)

        return data
      end

      def callWithCode(phoneNumber, code, lang)
        if phoneNumber.length == 0
          raise ArgumentError.new('the phoneNumber parameter is empty')
        end
        if code.length == 0
          raise ArgumentError.new('the code parameter is empty')
        end
        if lang.length == 0
          raise ArgumentError.new('the lang parameter is empty')
        end

        headers = {'Authorization': sprintf('Bearer %s', @jwt)}

        uri = makeFullURI('code/call')

        response = @httpClient.post(uri) do |req|
          req.headers = headers
          req.body = {
            'phone_number': phoneNumber,
            'code': code,
            'lang': lang,
          }.to_json
        end

        if response.status != 201
          raise RuntimeError.new(sprintf('Incorrect status code: %d on call step', response.status))
        end

        data = JSON.parse(response.body)

        return data
      end

      def callViaLastDigits(phoneNumber, poolID, useSixDigits = false)
        if phoneNumber.length == 0
          raise ArgumentError.new('the phoneNumber parameter is empty')
        end
        if poolID.length == 0
          raise ArgumentError.new('the poolID parameter is empty')
        end

        headers = {'Authorization': sprintf('Bearer %s', @jwt)}

        if useSixDigits
          uri = makeFullURI(sprintf('pool/%s/call/six-digits', poolID))
        else
          uri = makeFullURI(sprintf('pool/%s/call', poolID))
        end

        response = @httpClient.post(uri) do |req|
          req.headers = headers
          req.body = {
            'phone_number': phoneNumber,
          }.to_json
        end

        if response.status != 201
          raise RuntimeError.new(sprintf('Incorrect status code: %d on call step', response.status))
        end

        data = JSON.parse(response.body)

        return data
      end

      def info(id)
        if id.length == 0
          raise ArgumentError.new('the id parameter is empty')
        end

        headers = {'Authorization': sprintf('Bearer %s', @jwt)}

        uri = makeFullURI(sprintf('call/%s', id))

        response = @httpClient.get(uri) do |req|
          req.headers = headers
        end

        data = JSON.parse(response.body)

        return data
      end

      def makeFullURI(method)
        return sprintf('%s/%s/%s/', @baseURI, @version, method)
      end

    end
  end
end
