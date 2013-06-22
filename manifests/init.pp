################################################################################
##  Ubuntu 13.04 Puppet Manifest  ##############################################
################################################################################
# Copyright (C) 2013 Jason Unovitch, jason.unovitch@gmail.com                  #
#   https://github.com/junovitch                                               #
################################################################################
# Redistribution and use in source and binary forms, with or without           #
# modification, are permitted provided that the following conditions are met:  #
#                                                                              #
#    (1) Redistributions of source code must retain the above copyright        #
#    notice, this list of conditions and the following disclaimer.             #
#                                                                              #
#    (2) Redistributions in binary form must reproduce the above copyright     #
#    notice, this list of conditions and the following disclaimer in the       #
#    documentation and/or other materials provided with the distribution.      #
#                                                                              #
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED #
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF         #
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO   #
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,       #
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, #
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;  #
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,     #
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR      #
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF       #
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                   #
################################################################################
#
# Purpose: Provides a one-stop shop manifest to cover a standard desktop
# configuration on my Ubuntu 13.04 Linux machines. This was my first experience
# learning Puppet for configuration management and it can be broken down to
# be smaller... But it works for me so I'll leave it as is. Feel free to use
# it however you see fit.
#
# Location:
# etc/puppet/modules/ubuntu1304/manifests/init.pp
#
# Prerequisites:
# Get the 'apt' module - `puppet module install puppetlabs/apt`
#
# Also, if you are looking to use this you'll need multiple installer packages
# that cannot be redistributed or you should be getting on your own from the
# trusted source. You'll have to review and update accordingly.
#
# Usage:
# Specify using the module in the site.pp manifest.
#   node mycomputer {
#     include ubuntu1304
#   }
#
# Warnings:
# Currently doesn't check for the PPA to be added before installing a package.
# This will cause an error when it first tries to install a package before
# adding the PPA. It will pick up the PPA and install during the next catalog
# run.
#
# As of writing Google Earth will be manually installed
# from a *.deb package after the first run.  Assuming the files are in place
# on the puppetmaster, they will be downloaded to the host to be installed by
# hand.
#
# cd /usr/local/puppet-pkgs
# dpkg -i google-earth-stable_current_amd64.deb
# apt-get -f install
#
################################################################################


class ubuntu1304 {

  ##############################################################################
  # Set defaults for all Files
  ##############################################################################

  File {
    owner      => root,
    group      => root,
  }

  ##############################################################################
  # Security sensitive and snapshot repositories.  These are always the latest
  # for security reasons or because they change so fast.
  ##############################################################################

  package { 'firefox':
    ensure     => latest,
  }
  package { 'google-chrome-beta':
    ensure     => absent,
    before     => Package['google-chrome-stable'],
  }
  package { 'google-chrome-stable':
    ensure     => latest,
  }
  apt::ppa { 'ppa:stebbins/handbrake-snapshots': }
  package { 'handbrake-gtk':
    ensure     => latest,
  }
  package { 'icedtea-plugin':
    ensure     => latest,
  }
  package { 'icedtea-7-plugin':
    ensure     => latest,
  }
  package { 'openjdk-7-jre':
    ensure     => latest,
  }
  package { 'skype':
    ensure     => latest,
  }
  package { 'thunderbird':
    ensure     => latest,
  }
  package { 'ubuntu-restricted-addons':
    ensure     => latest,
  }
  package { 'ubuntu-restricted-extras':
    ensure     => latest,
  }

  ##############################################################################
  # General Security tools
  ##############################################################################

  package { 'apparmor-profiles':
    ensure     => installed,
  }
  package { 'bleachbit':
    ensure     => installed,
  }
  package { 'chkrootkit':
    ensure     => installed,
  }
  package { 'clamav':
    ensure     => installed,
  }
  package { 'clamtk':
    ensure     => installed,
  }
  package { 'ecryptfs-utils':
    ensure     => installed,
  }
  package { 'fail2ban':
    ensure     => installed,
  }
  package { 'gufw':
    ensure     => installed,
  }
  package { 'kismet':
    ensure     => installed,
  }
  package { 'nmap':
    ensure     => installed,
  }
  package { 'openvpn':
    ensure     => installed,
  }
  package { 'putty':
    ensure     => installed,
  }
  package { 'sockstat':
    ensure     => installed,
  }
  package { 'tshark':
    ensure     => installed,
  }
  package { 'wireshark':
    ensure     => installed,
  }
  package { 'wireshark-doc':
    ensure     => installed,
  }

  ##############################################################################
  # Encfs Home directory support
  # http://wiki.debian.org/TransparentEncryptionForHomeFolder
  ##############################################################################

  package { 'fuse':
    ensure     => installed,
  }
  package { 'encfs':
    ensure     => installed,
  }
  package { 'libpam-encfs':
    ensure     => installed,
  }
  package { 'libpam-mount':
    ensure     => installed,
  }
  file { '/etc/fuse.conf':
    source     => 'puppet:///modules/ubuntu1304/common/etc/fuse.conf',
    group      => fuse,
    mode       => '0640',
    require    => Package['fuse'],
  }
  file { '/etc/security/pam_env.conf':
    source     => 'puppet:///modules/ubuntu1304/common/etc/security/pam_env.conf',
    mode       => '0644',
    require    => [ Package['libpam-encfs'], Package['encfs'] ],
  }
  file { '/etc/security/pam_encfs.conf':
    source     => 'puppet:///modules/ubuntu1304/common/etc/security/pam_encfs.conf',
    mode       => '0644',
    require    => [ Package['libpam-encfs'], Package['encfs'] ],
  }
  file { '/etc/pam.d/common-session':
    source     => 'puppet:///modules/ubuntu1304/common/etc/pam.d/common-session',
    mode       => '0644',
    require    => [ Package['libpam-encfs'], Package['encfs'] ],
  }

  ##############################################################################
  # Games
  ##############################################################################

  package { 'playonlinux':
    ensure     => installed,
  }
  package { 'openttd':
    ensure     => installed,
  }
  package { 'openttd-opensfx':
    ensure     => installed,
  }

  ##############################################################################
  # Steam + Dependencies
  ##############################################################################

  package { 'curl':
    ensure     => installed,
  }
  package { 'jockey-common':
    ensure     => installed,
  }
  package { 'nvidia-common':
    ensure     => installed,
  }
  package { 'python-xkit':
    ensure     => installed,
  }
  package { 'steam-launcher':
    ensure    => installed,
    provider  => dpkg,
    source    => '/usr/local/puppet-pkgs/steam.deb',
    require   => [ Package['curl'], Package['jockey-common'], Package['nvidia-common'], Package['python-xkit'], File['/usr/local/puppet-pkgs'] ],
  }

  ##############################################################################
  # Photography Applications
  ##############################################################################

  package { 'gimp':
    ensure     => installed,
  }
  package { 'gimp-data':
    ensure     => installed,
  }
  package { 'gimp-data-extras':
    ensure     => installed,
  }
  package { 'gimp-help-en':
    ensure     => installed,
  }
  package { 'hugin':
    ensure     => installed,
  }
  package { 'mypaint':
    ensure     => installed,
  }
  package { 'pandora':
    ensure     => installed,
  }
  package { 'pinta':
    ensure     => installed,
  }
  package { 'shotwell':
    ensure     => installed,
  }

  ##############################################################################
  # CLI Apps
  ##############################################################################

  package { 'clusterssh':
    ensure     => installed,
  }
  package { 'htop':
    ensure     => installed,
  }
  package { 'tcsh':
    ensure     => installed,
  }
  package { 'terminator':
    ensure     => installed,
  }
  package { 'tmux':
    ensure     => installed,
  }
  package { 'zsh':
    ensure     => installed,
  }
  package { 'zsh-doc':
    ensure     => installed,
  }

  ##############################################################################
  # System Apps
  ##############################################################################

  package { 'blueman':
    ensure     => installed,
  }
  package { 'gconf-editor':
    ensure     => installed,
  }
  package { 'gddrescue':
    ensure     => installed,
  }
  package { 'gparted':
    ensure     => installed,
  }
  apt::ppa { 'ppa:danielrichter2007/grub-customizer': }
  package { 'grub-customizer':
    ensure     => installed,
  }
  package { 'preload':
    ensure     => installed,
  }
  package { 'remmina':
    ensure     => installed,
  }
  package { 'synaptic':
    ensure     => installed,
  }
  package { 'traceroute':
    ensure     => installed,
  }
  package { 'etherwake':
    ensure     => installed,
  }
  package { 'wakeonlan':
    ensure     => installed,
  }

  ##############################################################################
  # Development Tools and Applications
  ##############################################################################

  package { 'build-essential':
    ensure     => installed,
  }
  package { 'byobu':
    ensure     => installed,
  }
  package { 'bzr':
    ensure     => installed,
  }
  package { 'bzr-explorer':
    ensure     => installed,
  }
  package { 'bzr-git':
    ensure     => installed,
  }
  package { 'charm-tools':
    ensure     => installed,
  }
  package { 'charm-helper-sh':
    ensure     => installed,
  }
  package { 'check':
    ensure     => installed,
  }
  package { 'checkinstall':
    ensure     => installed,
  }
  package { 'cdbs':
    ensure     => installed,
  }
  package { 'devscripts':
    ensure     => installed,
  }
  package { 'dh-make':
    ensure     => installed,
  }
  package { 'eclipse':
    ensure     => installed,
  }
  package { 'fakeroot':
    ensure     => installed,
  }
  package { 'geany':
    ensure     => installed,
  }
  package { 'geany-plugins':
    ensure     => installed,
  }
  package { 'git':
    ensure     => installed,
  }
  package { 'git-core':
    ensure     => installed,
  }
  package { 'juju':
    ensure     => installed,
  }
  package { 'kexec-tools':
    ensure     => installed,
  }
  package { 'meld':
    ensure     => installed,
  }
  package { 'perl-tk':
    ensure     => installed,
  }
  package { 'qtcreator':
    ensure     => installed,
  }
  package { 'quickly':
    ensure     => installed,
  }
  package { 'subversion':
    ensure     => installed,
  }
  package { 'sharutils':
    ensure     => installed,
  }
  package { 'uudeview':
    ensure     => installed,
  }
  package { 'vim':
    ensure     => installed,
  }
  package { 'vim-gnome':
    ensure     => installed,
  }
  package { 'vim-doc':
    ensure     => installed,
  }
  package { 'vim-scripts':
    ensure     => installed,
  }
  package { 'vim-latexsuite':
    ensure     => installed,
  }

  ##############################################################################
  # BlackBerry tools
  ##############################################################################

  package { 'barrydesktop':
    ensure     => installed,
  }

  ##############################################################################
  # HPLIP Printer Tools
  ##############################################################################

  package { 'hplip-gui':
    ensure     => installed,
  }

  ##############################################################################
  # Smartcard Support
  ##############################################################################

  package { 'libpcsclite1':
    ensure     => installed,
  }
  package { 'pcscd':
    ensure     => installed,
  }
  package { 'pcsc-tools':
    ensure     => installed,
  }

  ##############################################################################
  # Media Players
  ##############################################################################

  package { 'banshee':
    ensure     => installed,
  }
  package { 'banshee-extension-ampache':
    ensure     => installed,
  }
  package { 'vlc':
    ensure     => installed,
  }
  apt::ppa { 'ppa:ehoover/compholio': }
  package { 'netflix-desktop':
    ensure     => installed,
  }

  ##############################################################################
  # Audio Tools
  ##############################################################################

  package { 'audacity':
    ensure     => installed,
  }
  package { 'icedax':
    ensure     => installed,
  }
  package { 'id3tool':
    ensure     => installed,
  }
  package { 'id3v2':
    ensure     => installed,
  }
  package { 'pavucontrol':
    ensure     => installed,
  }
  package { 'sox':
    ensure     => installed,
  }
  package { 'tagtool':
    ensure     => installed,
  }

  ##############################################################################
  # Video Tools
  ##############################################################################

  package { 'blender':
    ensure     => installed,
  }
  package { 'cheese':
    ensure     => installed,
  }
  package { 'devede':
    ensure     => installed,
  }
  package { 'openshot':
    ensure     => installed,
  }
  package { 'openshot-doc':
    ensure     => installed,
  }
  package { 'mkvtoolnix':
    ensure     => installed,
  }
  package { 'mkvtoolnix-gui':
    ensure     => installed,
  }

  ##############################################################################
  # Web Applications & Tools
  ##############################################################################

  package { 'bluefish':
    ensure     => installed,
  }
  package { 'clamz':
    ensure     => installed,
  }
  package { 'mpack':
    ensure    => installed,
  }

  ##############################################################################
  # Web Communication Apps
  ##############################################################################

  package { 'pidgin':
    ensure     => installed,
  }
  package { 'pidgin-otr':
    ensure     => installed,
  }
  package { 'pidgin-encryption':
    ensure     => installed,
  }

  ##############################################################################
  # Virtualization
  ##############################################################################

  package { 'virtualbox-qt':
    ensure     => installed,
  }
  package { 'virtualbox-guest-additions-iso':
    ensure     => installed,
  }
  package { 'gns3':
    ensure     => installed,
  }

  ##############################################################################
  # Document tools
  ##############################################################################

  package { 'lyx':
    ensure     => installed,
  }
  package { 'pdfshuffler':
    ensure     => installed,
  }

  ##############################################################################
  # Desktop Apps
  ##############################################################################

  package { 'conky-all':
    ensure     => installed,
  }
  package { 'gtk-redshift':
    ensure     => installed,
  }
  package { 'wbar':
    ensure     => installed,
  }

  ##############################################################################
  # Google Earth
  ##############################################################################

  package { 'lsb-core':
    ensure     => installed,
  }
  package { 'google-earth-stable':
    ensure     => installed,
  }

  ##############################################################################
  # General File Manipulation Tools
  ##############################################################################

  package { 'cabextract':
    ensure     => installed,
  }
  package { 'mdbtools':
    ensure     => installed,
  }
  package { 'mdbtools-doc':
    ensure     => installed,
  }
  package { 'mdbtools-gmdb':
    ensure     => installed,
  }
  package { 'p7zip-full':
    ensure     => installed,
  }
  package { 'rar':
    ensure     => installed,
  }
  package { 'unrar':
    ensure     => installed,
  }
  package { 'unzip':
    ensure     => installed,
  }
  package { 'zip':
    ensure     => installed,
  }

  ##############################################################################
  # Codecs
  # Notes for Blu-ray:  http://vlc-bluray.whoknowsmy.name/
  ##############################################################################

  package { 'faac':
    ensure     => installed,
  }
  package { 'flac':
    ensure     => installed,
  }
  package { 'lame':
    ensure     => installed,
  }
  package { 'libmad0':
    ensure     => installed,
  }
  package { 'libquicktime2':
    ensure     => installed,
  }
  package { 'totem-mozilla':
    ensure     => installed,
  }
  file { '/usr/lib64/libaacs.so.0':
    source     => 'puppet:///modules/ubuntu1304/common/usr/lib64/libaacs.so.0',
    mode       => '0644',
    require    => File['/usr/lib64'],
  }
  file { '/etc/skel/.config':
    ensure    => directory,
    mode      => '0755',
  }
  file { '/etc/skel/.config/aacs':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0755',
    source    => 'puppet:///modules/ubuntu1304/common/etc/skel/.config/aacs',
    require   => File['/etc/skel/.config'],
  }

  ##############################################################################
  # Alternate Desktops
  ##############################################################################

  package { 'cinnamon':
    ensure     => installed,
  }
  package { 'kde-plasma-desktop':
    ensure     => installed,
  }
  package { 'unity':
    ensure     => installed,
  }
  package { 'unity-tweak-tool':
    ensure     => installed,
  }
  package { 'unity-lens-shopping':
    ensure     => absent,
  }
  package { 'xfce4':
    ensure     => installed,
  }

  ##############################################################################
  # OpenSSH Server, Unison, and associated configurations
  ##############################################################################

  package { 'openssh-server':
    ensure     => installed,
  }
  package { 'openssh-blacklist':
    ensure     => installed,
  }
  package { 'openssh-blacklist-extra':
    ensure     => installed,
  }
  package { 'ssh-import-id':
    ensure     => installed,
  }
  package { 'unison':
    ensure     => installed,
  }
  package { 'unison-gtk':
    ensure     => installed,
  }
  file { '/etc/ssh/sshd_config':
    source     => 'puppet:///modules/ubuntu1304/common/etc/ssh/sshd_config',
    mode       => '0640',
    notify     => Service['ssh'],
    require    => Package['openssh-server'],
  }
  file { '/root/.ssh':
    ensure    => directory,
    mode      => '0700',
  }
  file { '/root/.ssh/authorized_keys':
    source     => 'puppet:///modules/ubuntu1304/common/root/.ssh/authorized_keys',
    mode       => '0600',
    require    => File['/root/.ssh'],
  }
  file { '/root/.ssh/id_ecdsa':
    source     => "puppet:///modules/ubuntu1304/common/root/.ssh/${hostname}-id_ecdsa",
    mode       => '0600',
    require    => File['/root/.ssh'],
  }
  file { '/root/.ssh/id_ecdsa.pub':
    source     => "puppet:///modules/ubuntu1304/common/root/.ssh/${hostname}-id_ecdsa.pub",
    mode       => '0644',
    require    => File['/root/.ssh'],
  }
  file { '/root/.unison':
    ensure    => directory,
    mode      => '0755',
  }
  file { '/root/.unison/accountSync.prf':
    source     => 'puppet:///modules/ubuntu1304/common/root/.unison/accountSync.prf',
    mode       => '0644',
    require    => File['/root/.unison'],
  }
  file { '/etc/cron.daily/accountSync.sh':
    mode       => '0755',
    source     => 'puppet:///modules/ubuntu1304/common/etc/cron.daily/accountSync.sh',
  }
  service { 'ssh':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  ##############################################################################
  # NFS client and Autofs with associated configurations
  ##############################################################################

  package { 'nfs-common':
    ensure     => installed,
  }
  package { 'autofs':
    ensure     => installed,
  }
  file { '/etc/idmapd.conf':
    mode       => '0644',
    source     => 'puppet:///modules/ubuntu1304/common/etc/idmapd.conf',
    require    => Package['nfs-common'],
  }
  file { '/etc/default/nfs-common':
    mode       => '0644',
    source     => 'puppet:///modules/ubuntu1304/common/etc/default/nfs-common',
    require    => Package['nfs-common'],
  }

  ##############################################################################
  # User Avatar Photos (purge => false to just put avatars in place)
  ##############################################################################

  file { '/var/lib/AccountsService':
    ensure    => directory,
    recurse   => true,
    purge     => false,
    mode      => '0644',
    source    => 'puppet:///modules/ubuntu1304/common/var/lib/AccountsService',
  }

  ##############################################################################
  # Scripts present on all systems
  ##############################################################################

  file { '/usr/local/bin':
    ensure     => directory,
    recurse    => true,
    purge      => false,
    source     => 'puppet:///modules/ubuntu1304/common/usr/local/bin',
    mode       => '0755',
  }

  ##############################################################################
  # Local puppet installation files
  ##############################################################################

  file { '/usr/local/puppet-pkgs':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0755',
    source    => 'puppet:///modules/ubuntu1304/common/usr/local/puppet-pkgs',
  }

  ##############################################################################
  # Keep /tmp in RAM
  ##############################################################################

  mount { '/tmp':
    ensure    => mounted,
    atboot    => true,
    device    => 'none',
    fstype    => 'tmpfs',
    options   => 'rw,nosuid,nodev,mode=01777',
  }

  ##############################################################################
  # CACKEY installation files and directory prerequisites
  ##############################################################################

  file { '/usr/lib64':
    ensure    => directory,
    mode      => '0755',
  }
  package { 'cackey':
    ensure    => latest,
    provider  => dpkg,
    source    => '/usr/local/puppet-pkgs/cackey_0.6.5-1_amd64.deb',
    require   => [ File['/usr/lib64'], File['/usr/local/puppet-pkgs'] ],
  }

  ##############################################################################
  # SCM Smart Card Drivers in place
  ##############################################################################

  file { '/usr/local/scm':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    source    => 'puppet:///modules/ubuntu1304/common/usr/local/scm',
  }

  file { '/usr/local/pcsc':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    source    => 'puppet:///modules/ubuntu1304/common/usr/local/pcsc',
  }

  file { '/usr/local/lib/pcsc':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    source    => 'puppet:///modules/ubuntu1304/common/usr/local/lib/pcsc',
  }

  ##############################################################################
  # Truecrypt binary and support files in place
  ##############################################################################

  file { '/usr/bin/truecrypt':
    source     => 'puppet:///modules/ubuntu1304/common/usr/bin/truecrypt',
    mode       => '0755',
  }

  file { '/usr/bin/truecrypt-uninstall.sh':
    source     => 'puppet:///modules/ubuntu1304/common/usr/bin/truecrypt-uninstall.sh',
    mode       => '0754',
  }

  file { '/usr/share/applications/truecrypt.desktop':
    source     => 'puppet:///modules/ubuntu1304/common/usr/share/applications/truecrypt.desktop',
    mode       => '0644',
  }

  file { '/usr/share/pixmaps/truecrypt.xpm':
    source     => 'puppet:///modules/ubuntu1304/common/usr/share/pixmaps/truecrypt.xpm',
    mode       => '0644',
  }

  file { '/usr/share/truecrypt':
    ensure    => directory,
    recurse   => true,
    purge     => true,
    mode      => '0644',
    source    => 'puppet:///modules/ubuntu1304/common/usr/share/truecrypt',
  }
}

class ubuntu1304::devel {

  ##############################################################################
  # Development Stuff only
  ##############################################################################

}

class ubuntu1304::silverstone {

  ##############################################################################
  # Silverstone Specific
  ##############################################################################

  apt::ppa { 'ppa:zfs-native/stable': }
  package { 'ubuntu-zfs':
    ensure     => installed,
  }

  apt::ppa { 'ppa:happy-neko/ps3mediaserver': }
  package { 'ps3mediaserver':
    ensure     => installed,
  }
  file { '/etc/default/ps3mediaserver':
    mode       => '0644',
    source     => 'puppet:///modules/ubuntu1304/silverstone/etc/default/ps3mediaserver',
    notify     => Service['ps3mediaserver'],
    require    => Package['ps3mediaserver'],
  }
  file { '/etc/skel/.config/ps3mediaserver/PMS.conf':
    mode       => '0644',
    source     => 'puppet:///modules/ubuntu1304/silverstone/etc/skel/.config/ps3mediaserver/PMS.conf',
    require    => Package['ps3mediaserver'],
  }
  group { 'ps3mediaserver':
    ensure     => present,
    system     => 'true',
    require    => Package['ps3mediaserver'],
  }
  user { 'ps3mediaserver':
    ensure     => present,
    system     => 'true',
    gid        => 'ps3mediaserver',
    password   => '*',
    shell      => '/bin/false',
    home       => '/home/ps3mediaserver',
    comment    => 'PS3 Media Server User,,,',
    managehome => true,
    require    => [ Group['ps3mediaserver'], File['/etc/skel/.config/ps3mediaserver/PMS.conf'], File['/etc/default/ps3mediaserver'] ],
  }
  service { 'ps3mediaserver':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => User['ps3mediaserver'],
  }

  package { 'boinc':
    ensure     => installed,
  }

  file { '/etc/cron.daily/rollingsnap':
    mode       => '0755',
    source     => 'puppet:///modules/ubuntu1304/silverstone/etc/cron.daily/rollingsnap',
  }
}

class ubuntu1304::coolermaster {

  ##############################################################################
  # Coolermaster Specific
  ##############################################################################

  file { '/etc/auto.master':
    mode       => '0644',
    source     => 'puppet:///modules/ubuntu1304/coolermaster/etc/auto.master',
    notify     => Service['autofs'],
    require    => Package['autofs'],
  }

  file { '/etc/auto.home':
    mode       => '0644',
    source     => 'puppet:///modules/ubuntu1304/coolermaster/etc/auto.home',
    notify     => Service['autofs'],
    require    => Package['autofs'],
  }

  service { 'autofs':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}

class ubuntu1304::withopenvpn {

  ##############################################################################
  # Include OpenVPN configuration Template
  ##############################################################################

  file { '/etc/openvpn/ca.crt':
    source     => 'puppet:///modules/ubuntu1304/common/etc/openvpn/ca.crt',
    mode       => '0644',
    require    => Package['openvpn'],
  }
  file { '/etc/openvpn/ta.key':
    source     => 'puppet:///modules/ubuntu1304/common/etc/openvpn/ta.key',
    mode       => '0600',
    require    => Package['openvpn'],
  }
  file { "/etc/openvpn/${hostname}.crt":
    source     => "puppet:///modules/ubuntu1304/common/etc/openvpn/${hostname}.crt",
    mode       => '0644',
    require    => Package['openvpn'],
  }
  file { "/etc/openvpn/${hostname}.key":
    source     => "puppet:///modules/ubuntu1304/common/etc/openvpn/${hostname}.key",
    mode       => '0600',
    require    => Package['openvpn'],
  }
  file { '/etc/openvpn/unovpn.conf':
    content    => template('ubuntu1304/etc/openvpn/unovpn.conf.erb'),
    mode       => '0600',
    require    => [ Package['openvpn'], File["/etc/openvpn/${hostname}.crt"], File["/etc/openvpn/${hostname}.key"] ],
  }
}
