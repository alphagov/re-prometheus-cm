# # encoding: utf-8

# Inspec test for recipe gds-tools-prometheus::default

variable_info = JSON.parse(File.read('test/intergration/variables/test_data.json'))

control 'gds_user_check' do
  if variable_info['users']
    variable_info['users'].each do |userinfo|
      describe user(userinfo['username'].strip) do
        it { should exist }
        its('groups') { should include userinfo['group'].strip }
        its('shell') { should eq userinfo['shell'].strip }
      end
    end
  end

end