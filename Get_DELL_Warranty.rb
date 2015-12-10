require 'savon'

wdsl = "http://xserv.dell.com/services/assetservice.asmx?WSDL"
guid = "11111111-1111-1111-1111-111111111111"
application = "AssetService"


if ARGV.size != 2
  puts "Usage: get_dell_warranty <servicetag> <y|n>"
  exit
end

servicetag = ARGV[0]
print_header = ARGV[1]

client = Savon.client(wsdl: wdsl)
response = client.call(:get_asset_information, message: {guid: guid, applicationName: application, serviceTags: servicetag })

results = Hash.new

asset = response.body[:get_asset_information_response][:get_asset_information_result][:asset]

to_print = asset[:asset_header_data]

to_add = Hash.new

if asset.has_key?(:entitlements)
  if asset[:entitlements].has_key?(:entitlement_data)
    to_add = asset[:entitlements][:entitlement_data].max_by { |data_a| data_a[:end_date] }
  end
end

to_print.merge!(to_add)

if print_header == "y"
 to_print.each_key { |k| print "#{k}," }
 p ''
end
to_print.each_value { |v| print "#{v}," }
  p ''




