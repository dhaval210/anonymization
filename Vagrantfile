
$pg14_script = <<SCRIPT
  apt-get update
  apt-get install -y postgresql-14 postgresql-server-dev-14 make gcc
  sudo -u postgres createdb foo
  add-apt-repository --yes "deb [trusted=yes] https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -s -c)-pgdg-snapshot main 16"
SCRIPT

$pg16_script = <<SCRIPT
  dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  dnf -y install yum-utils
  yum-config-manager --enable pgdg16-updates-testing
  dnf -y install gcc ccache redhat-rpm-config postgresql16-server postgresql16-contrib postgresql16-devel
  export PATH="/usr/pgsql-16/bin:$PATH"
SCRIPT

$pg15dev_script = <<SCRIPT
  apt-get update
  apt-get install -y git make gcc libreadline-dev zlib1g-dev bison flex libssl-dev
  git clone --depth=1 -b REL_15_STABLE https://github.com/postgres/postgres.git
  cd postgres
  ./configure --enable-cassert --enable-debug --with-ssl=openssl
  make
  make all
  make -C contrib/pgcrypto
  make world-bin
  make install-world-bin
  make -C contrib/pgcrypto install
  cat >> /etc/profile.d/postgres.sh << \EOF
  PATH=$PATH:/usr/local/pgsql/bin
  EOF
  adduser --system postgres
  mkdir -p /usr/local/pgsql/data
  chown postgres: /usr/local/pgsql/data
  su postgres -c '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data'
  su postgres -c '/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /home/postgres/logfile start'


SCRIPT

Vagrant.configure("2") do |config|

  config.vm.define "pg14" do |pg14|
    pg14.vm.box = "ubuntu/jammy64"
    pg14.vm.hostname = "pg14"
    pg14.vm.network :forwarded_port, guest: 5432, host: 54314
    pg14.vm.provision "shell", inline: $pg14_script
  end

  config.vm.define "pg16" do |pg16|
    pg16.vm.box = "CrunchyData/rocky9"
    pg16.vm.hostname = "pg16"
    pg16.vm.network :forwarded_port, guest: 5432, host: 54316
    pg16.vm.provision "shell", inline: $pg16_script
  end

  config.vm.define "pg15dev" do |pg15dev|
    pg15dev.vm.box = "ubuntu/jammy64"
    pg15dev.vm.hostname = "pg15dev"
    pg15dev.vm.network :forwarded_port, guest: 5432, host: 54315
    pg15dev.vm.provision "shell", inline: $pg15dev_script
  end
end

