# # encoding: utf-8

# Inspec test for recipe gds-tools-prometheus::default

variable_info = JSON.parse(File.read('test/intergration/variables/test_data.json'))

control 'gds_check_prometheus' do
  if variable_info['users']
    variable_info['users'].each do |userinfo|
      describe user(userinfo['username'].strip) do
        it { should exist }
        its('group') { should eq userinfo['group'].strip }
        its('shell') { should eq userinfo['shell'].strip }
      end
    end
  end

  if variable_info['files']
    variable_info['files'].each do |fileinfo|
      describe user(fileinfo['location'].strip) do
        it { should exist }
        it { should be_owned_by fileinfo['ownerby'].strip }
        its('group') { should match fileinfo['group'].strip }
        its('mode')  { should cmp '0644' }
      end
    end
  end

  if variable_info['services']
      variable_info['services'].each do |servicesinfo|

      describe service(servicesinfo['name'].strip) do
        it { should be_running }
        it { should be_enabled }
      end
    end
  end

  if variable_info['packages']
      variable_info['packages'].each do |packagesinfo|

      describe package(packagesinfo['name'].strip) do
        it { should be_installed }
      end
    end
  end
end



