require 'spec_helper'

describe "maven" do
  it do
    should contain_file('/usr/local/apache-maven-3.1.1').with({
      :source  => 'puppet:///modules/java/java.sh',
      :mode    => '0755',
      :require => 'Package[java]'
    })
    should contain_file ('/usr/local/maven').with({
      :ensure  => 'link',
      :target  => '/usr/local/apache-maven-3.1.1',
    })
    should contain_file('/opt/boxen/bin/mvn').with({
      :ensure  => 'link',
      :target  => '/usr/local/maven/bin/mvn',
    })
  end
end
