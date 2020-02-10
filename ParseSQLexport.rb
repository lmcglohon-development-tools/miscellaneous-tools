require 'json'
file = File.new("relTest2_1_0_2017-07-19.sql", "r")
data = []
while (line = file.gets)
  next if line.strip.empty? || line.start_with?('#') ||
          line.start_with?('/*') || line.start_with?('/*') ||
          line.start_with?('--') || line.start_with?('DELIMITER')
  if line.start_with?('CREATE TABLE')
    table_field = []
    table_pri_key = []
    table_uniq_key = []
    table_contraints = []
    table_key = []
    table_name = line.chomp.split(' ')
    until line.start_with?(") ENGINE=InnoDB") do
      line = file.gets
      line_start = line[2]
      case line_start
      when /`/
        # Table Fields
        f = line.strip.chomp.split(' ')
        table_field << {"field_name": f[0].gsub('`', ''),"field_type": f[1]}
      when /C/
        #  CONSTRAINT `agent_contact_ibfk_1` FOREIGN KEY (`salutation_id`) REFERENCES `enumeration_value` (`id`),
        c = line.strip.chomp.split(' ')
        table_contraints << {"constraint_name": c[1].gsub('`', ''),"foreign_key": c[4].gsub('`', '').gsub('(', '').gsub(')', ''),"references": {"ref_table": c[6].gsub('`', ''),"ref_field": c[7].gsub('`', '').gsub('(', '').gsub(')', '')}}
      when /K/
        #  KEY `salutation_id` (`salutation_id`),
        k = line.strip.chomp.split(' ')
        table_key << {"key_name": k[1].gsub('`', ''),"key_field": k[2].gsub('`', '').gsub('(', '').gsub(')', '')}
      when /P/
        #  PRIMARY KEY (`id`),
        pk = line.strip.chomp.split(' ')
        table_pri_key << {"primary_key_name": pk[2].gsub('`', '').gsub('(', '').gsub(')', '')}
      when /U/
        #  UNIQUE KEY `sha1_agent_corporate_entity` (`agent_sha1`),
        uk = line.strip.chomp.split(' ')
        table_uniq_key << {"unique_key_name": uk[2].gsub('`', ''),"unique_key_field": uk[3].gsub('`', '').gsub('(', '').gsub(')', '')}
      end
    end
    data << {"table": table_name[2].gsub('`', ''),"fields": table_field,"constraints": table_contraints,"keys": table_key,"primary_keys": table_pri_key,"unique_keys": table_uniq_key}
  end
end
file.close
output = File.open( "outputfile.json", "w" )
output << data.to_json
output.close
