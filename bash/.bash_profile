#  ----------------------------------------------------------------------------
#
#  Modeled after this article: https://natelandau.com/my-mac-osx-bash_profile/
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.  Environment Configurations
#  2.  Make Terminal Better (remapping defaults and adding functinoality)
#  3.  File and Folder Management
#  4.  Searching
#  5.  Process Management
#  6.  Networking
#  7.  System Operations & Information
#  8.  Reminders & Notes
#
#  ----------------------------------------------------------------------------

#  -------------------------------
#  1. Environment Configurations
#  -------------------------------

#  Change Prompt - we will use the 'oh-my-git' repo
#  https://github.com/arialdomartini/oh-my-git
#  Required font can be found here: https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched
#  -----------------------------------------------------------------
   source /Users/nightsun/.oh-my-git/prompt.sh

#  Set Paths
#  -----------------------------------------------------------------
#  Empty for now, but if you need to set Path it would go here
#  and it would look something like: export PATH="$PATH:/usr/local/bin"

#  Set Default Editor
#  -----------------------------------------------------------------
   export EDITOR=/usr/bin/vim


#  -------------------------------
#  2. Make Terminal Better
#  -------------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias edit='subl'                           # edit:      Opens any file in sublime editor
trash () { command mv "$@" ~/.Trash ; }     # trash:     Moves a file to the macOS trash
ql () { qlmanage -p "$*" >& /dev/null ; }   # ql:        Opens any file in macOS Quicklook Preview

#  lr:  Full Recursive Directory Listing
#  -----------------------------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#  mans:  Search manpage given in argument '1' for termin given in argument '2' (case insensitive)
#         displays paginated results with colored search terms and two lines surrounding each hit.
#  -----------------------------------------------------------------
mans () {
    man $1 | grep -iC2 --color=always $2 | less
}

#  -------------------------------
#  3. File and Folder Management
#  -------------------------------

zipf () { zip -r "$1".zip "$1" ; }       # zipf:       To create a ZIP archive of a folder
alias numFiles="echo $(ls -1 | wc -l)"   # numFiles:   Count of non-hidden files in current dir

#  extract:  Extract most known archives with one command
#  -----------------------------------------------------------------
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)    tar sjf $1    ;;
            *.tar.gz)     tar xzf $1    ;;
            *.bz2)        bunzip2 $1    ;;
            *.rar)        unrar e $1    ;;
            *.gz)         gunzip $1     ;;
            *.tar)        tar xf $1     ;;
            *.tbz2)       tar xjf $1    ;;
            *.tgz)        tar xzf $1    ;;
            *.zip)        unzip $1      ;;
            *.Z)          uncompress $1 ;;
            *.7z)         7z x $1       ;;
            *)  echo "'$1 cannot be extracted via extract()" ;;
             esac
        else
            echo "'$1' is not a valid file"
    fi
}


#  -------------------------------
#  4. Searching
#  -------------------------------

alias qfind="find . -name "                   # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }        # ff:       Find file under the current dir
ffs () { /usr/bin/find . -name "$@"'*' ; }    # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }    # ffe:      Find file whose name ends with a given string

#  spotlight: Search for a file using macOS Spotlights metadata
#  -----------------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc" ; }



#  -------------------------------
#  5. Process Management
#  -------------------------------

#  findPid:  find out the pid of a specified process
#  -----------------------------------------------------------------
#      Note that the command name can be speficied via a reges
#      E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#      Without the 'sudo' it will only find processes of the current user
#  -----------------------------------------------------------------
findPid () { lsof -t -c "$@" ; }

#  memHotsTop, memHogsPs:  Find memory hogs
#  -----------------------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#  cpuHogs:  Find CPU hogs
#  -----------------------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#  topForever:  Continual 'top' listing (every 10 seconds)
#  -----------------------------------------------------------------
alias topForever='top -l 9999999 -s 10 -o cpu'

#  ttop:  Recommended 'top' invocation to minimize resources
#  -----------------------------------------------------------------
alias ttop='top -R -F -s 10 -o rsize'

#  my_ps:  List processes owned by my user:
#  -----------------------------------------------------------------
my_ps () { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#  -------------------------------
#  6. Networking
#  -------------------------------

alias myip='curl ifconfig.co'                           #  myip:        Public facing IP address
alias netCons='lsof -i'                                 #  netCons:     Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'                #  flushDNS:    Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'                 #  lsock:       Display open sockets
alias openPorts='sudo lsof -i | grep LISTEN'            #  openPorts:   All listening connections
alias showBlocked='sudo ipfw list'                      #  showBlocked: All ipfw rules inc/ blocked IPs


#  -------------------------------------
#  7. System Operations & Information
#  -------------------------------------

#  finderShowHidden:  Show hidden files in Finder
#  finderHideHidden:  Hide hidden files in Finder
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   ---------------------------------------
#   9. REMINDERS & NOTES
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat
