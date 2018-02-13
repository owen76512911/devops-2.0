#!/bin/sh -eux
# create new user with associated groups on centos linux 7.x.

# set default values for input environment variables if not set. ---------------
user_name="${user_name:-}"                                  # user name.
user_password="${user_password:-}"                          # user password.
user_group="${user_group:-}"                                # user login group.
user_id="${user_id:-}"                                      # [optional] custom user id.
user_comment="${user_comment:-$user_name}"                  # [optional] user comment [full name] (defaults to 'user_name').
user_supplementary_groups="${user_supplementary_groups:-}"  # [optional] comma separated list of groups.
user_sudo_privileges="${user_sudo_privileges:-false}"       # [optional] user sudo privileges boolean (defaults to 'false').
user_home="${user_home:-/home/$user_name}"                  # [optional] user home (defaults to '/home/user_name').
user_headless_env="${user_headless_env:-false}"             # [optional] user install headless environment (defaults to 'false').
                                                            #
devops_home="${devops_home:-/opt/devops}"                   # [optional] devops home (defaults to '/opt/devops').
                                                            #
                                                            # NOTE: if 'user_headless_env' is 'true'--
                                                            #       the following [optional] pass-thru env variables may be defined:
user_docker_profile="${user_docker_profile:-false}"         # [optional] user docker profile (defaults to 'false').
user_prompt_color="${user_prompt_color:-green}"             # [optional] user prompt color (defaults to 'green').
                                                            #            valid colors are:
                                                            #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'

# define usage function. -------------------------------------------------------
usage() {
  cat <<EOF
Usage:
  All inputs are defined by external environment variables.
  Script should be run with 'root' privilege.
  Example:
    [root]# export user_name="user1"                        # user name.
    [root]# export user_password="password"                 # user password.
    [root]# export user_group="group1"                      # user login group.
    [root]# export user_id="1001"                           # [optional] custom user id.
    [root]# export user_comment="user1"                     # [optional] user comment [full name] (defaults to 'user_name').
    [root]# export user_supplementary_groups="grp2,grp3"    # [optional] comma separated list of groups.
    [root]# export user_sudo_privileges="true"              # [optional] user sudo privileges boolean (defaults to 'false').
    [root]# export user_home="/home/user1"                  # [optional] user home (defaults to '/home/user_name').
    [root]# export user_headless_env="true"                 # [optional] user install headless environment (defaults to 'false').
                                                            #
    [root]# export devops_home="/opt/devops"                # [optional] devops home (defaults to '/opt/devops').
                                                            #
                                                            # NOTE: if 'user_headless_env' is 'true'--
                                                            #       the following [optional] pass-thru env variables may be defined:
    [root]# export user_docker_profile="true"               # [optional] user docker profile (defaults to 'false').
    [root]# export user_prompt_color="yellow"               # [optional] user prompt color (defaults to 'green').
                                                            #            valid colors:
                                                            #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'
    [root]# $0
EOF
}

# validate environment variables. ----------------------------------------------
if [ -z "$user_name" ]; then
  echo "Error: 'user_name' environment variable not set."
  usage
  exit 1
fi

if [ -z "$user_password" ]; then
  echo "Error: 'user_password' environment variable not set."
  usage
  exit 1
fi

if [ -z "$user_group" ]; then
  echo "Error: 'user_group' environment variable not set."
  usage
  exit 1
fi

if [ -n "$user_prompt_color" ]; then
  case $user_prompt_color in
      black|blue|cyan|green|magenta|red|white|yellow)
        ;;
      *)
        echo "Error: invalid 'user_prompt_color'."
        usage
        exit 1
        ;;
  esac
fi

# create user and add to associated groups. ------------------------------------
# check for custom user id.
if [ -n "$user_id" ]; then
  useradd ${user_name} -u ${user_id} -g ${user_group}
else
  useradd ${user_name} -g ${user_group}
fi

# modify default password.
echo "${user_name}:${user_password}" | chpasswd

# add user comment (usually a full name).
if [ -n "$user_comment" ]; then
  usermod -c "${user_comment}" ${user_name}
fi

# add user to supplementary groups.
if [ -n "$user_supplementary_groups" ]; then
  usermod -aG ${user_supplementary_groups} ${user_name}
fi

# add user to sudoers. ---------------------------------------------------------
if [ "$user_sudo_privileges" == "true" ]; then
  echo "%${user_group} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${user_group}
fi

# create environment profile for the user. -------------------------------------
if [ "$user_headless_env" == "true" ]; then
  # NOTE: if 'user_headless_env' is 'true'--
  #       the following [optional] pass-thru env variables may be defined:
  #         user_docker_profile:                            # [optional] user docker profile (defaults to 'false').
  #         user_prompt_color:                              # [optional] user prompt color (defaults to 'green').
  #            valid colors are:
  #              'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'white', 'yellow'
  cd ${devops_home}/provisioners/scripts/common
  chmod 755 install_headless_user_env.sh
  ./install_headless_user_env.sh
fi
