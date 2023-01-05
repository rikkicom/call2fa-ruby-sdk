lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rikkicom/client'

LOGIN = '***'
PASSWORD = '***'

CALL_ID = '21168326'

begin
    client = Rikkicom::Call2FA::Client.new(LOGIN, PASSWORD)

    call_info = client.info(CALL_ID)
    puts call_info
rescue ArgumentError => e
    puts "Something went wrong:" 
    puts e.message
rescue RuntimeError => e
    puts "Something went wrong:" 
    puts e.message
end
