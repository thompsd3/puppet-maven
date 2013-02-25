class maven {
  $maven_url = 'http://apache.komsys.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz'
  $maven_bundle = "/tmp/apache-maven-3.0.5-bin.tar.gz"

  file { $maven_bundle:
    ensure => present,
    require => Exec["Fetch maven"],
  }

  exec { "Fetch maven":
    cwd => "/tmp",
    command => "wget $maven_url",
    creates => $maven_bundle,
    path    => ["/opt/boxen/homebrew/bin"],
  }

  file { "/usr/local/apache-maven-3.0.5":
    require => Exec["Extract maven"],
  }

  exec { "Extract maven":
    cwd     => "/usr/local",
    command => "tar xvf $maven_bundle",
    creates => '/usr/local/apache-maven-3.0.5',
    path    => ["/usr/bin"],
    require => File[$maven_bundle]
  }

  file { "/usr/local/maven":
    ensure  => link,
    target  => "/usr/local/apache-maven-3.0.5",
    require => File['/usr/local/apache-maven-3.0.5'],
  }
  
  file { "${boxen::config::homedir}/bin/mvn": 
    ensure => link,
    target  => "/usr/local/maven/bin/mvn",
    require => File['/usr/local/maven'],

  }

}
