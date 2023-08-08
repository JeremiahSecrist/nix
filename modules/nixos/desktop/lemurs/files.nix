{
  pkgs,
  xsessionDir,
  xsessionOption,
}: {
  settings = {
    tty = 1;
    x11_display = ":1";
    xserver_timeout_secs = 60;
    main_log_path = "/tmp/lemurs.log";
    client_log_path = "/tmp/lemurs.client.log";
    xserver_log_path = "/tmp/lemurs.xorg.log";
    do_log = false;
    pam_service = "lemurs";
    shell_login_flag = "long";
    focus_behaviour = "default";
    background = {
      show_background = false;
    };
    background.style = {
      border_color = "white";
      show_border = true;
      color = "black";
    };

    power_controls = {
      allow_shutdown = true;
      shutdown_hint = "Shutdown %key%";
      shutdown_hint_color = "dark gray";
      shutdown_hint_modifiers = "";
      shutdown_key = "F1";
      shutdown_cmd = "${pkgs.systemd}/bin/systemctl poweroff -l";
      allow_reboot = true;
      reboot_hint = "Reboot %key%";
      reboot_hint_color = "dark gray";
      reboot_hint_modifiers = "";
      reboot_key = "F2";
      reboot_cmd = "${pkgs.systemd}/bin/systemctl reboot -l";
      hint_margin = 2;
    };

    environment_switcher = {
      switcher_visibility = "visible";
      toggle_hint = "Switcher %key%";
      toggle_hint_color = "dark gray";
      toggle_hint_modifiers = "";
      include_tty_shell = true;
      remember = true;
      show_movers = true;
      mover_color = "dark gray";
      mover_modifiers = "";
      mover_color_focused = "orange";
      mover_modifiers_focused = "bold";
      left_mover = "<";
      right_mover = ">";
      mover_margin = 1;
      show_neighbours = true;
      neighbour_color = "dark gray";
      neighbour_modifiers = "";
      neighbour_color_focused = "gray";
      neighbour_modifiers_focused = "";
      neighbour_margin = 1;
      selected_color = "gray";
      selected_modifiers = "underlined";
      selected_color_focused = "white";
      selected_modifiers_focused = "bold";
      max_display_length = 8;
      no_envs_text = "No environments...";
      no_envs_color = "white";
      no_envs_modifiers = "";
      no_envs_color_focused = "red";
      no_envs_modifiers_focused = "";
    };

    username_field = {
      remember = true;
      style = {
        show_title = true;
        title = "Login";
        title_color = "white";
        content_color = "white";
        title_color_focused = "orange";
        content_color_focused = "orange";
        show_border = true;
        border_color = "white";
        border_color_focused = "orange";
        use_max_width = true;
        max_width = 48;
      };
    };
    password_field = {
      content_replacement_character = "x";
      style = {
        show_title = true;
        title = "Password";
        title_color = "white";
        content_color = "white";
        title_color_focused = "orange";
        content_color_focused = "orange";
        show_border = true;
        border_color = "white";
        border_color_focused = "orange";
        use_max_width = true;
        max_width = 48;
      };
    };
  };
  xsetup = ''
    #! ${pkgs.bash}/bin/bash
    # Xsession - run as user
    # Copyright (C) 2016 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>

    # This file is extracted from kde-workspace (kdm/kfrontend/genkdmconf.c)
    # Copyright (C) 2001-2005 Oswald Buddenhagen <ossi@kde.org>

    # Note that the respective logout scripts are not sourced.
    case $SHELL in
      */bash)
        [ -z "$BASH" ] && exec $SHELL $0 "$@"
        set +o posix
        [ -f /etc/profile ] && . /etc/profile
        if [ -f $HOME/.bash_profile ]; then
          . $HOME/.bash_profile
        elif [ -f $HOME/.bash_login ]; then
          . $HOME/.bash_login
        elif [ -f $HOME/.profile ]; then
          . $HOME/.profile
        fi
        ;;
    */zsh)
        [ -z "$ZSH_NAME" ] && exec $SHELL $0 "$@"
        [ -d /etc/zsh ] && zdir=/etc/zsh || zdir=/etc
        zhome=''${ZDOTDIR:-$HOME}
        # zshenv is always sourced automatically.
        [ -f $zdir/zprofile ] && . $zdir/zprofile
        [ -f $zhome/.zprofile ] && . $zhome/.zprofile
        [ -f $zdir/zlogin ] && . $zdir/zlogin
        [ -f $zhome/.zlogin ] && . $zhome/.zlogin
        emulate -R sh
        ;;
      */csh|*/tcsh)
        # [t]cshrc is always sourced automatically.
        # Note that sourcing csh.login after .cshrc is non-standard.
        xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
        $SHELL -c "if (-f /etc/csh.login) source /etc/csh.login; if (-f ~/.login) source ~/.login; /bin/sh -c 'export -p' >! $xsess_tmp"
        . $xsess_tmp
        rm -f $xsess_tmp
        ;;
      */fish)
        [ -f /etc/profile ] && . /etc/profile
        xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
        $SHELL --login -c "/bin/sh -c 'export -p' > $xsess_tmp"
        . $xsess_tmp
        rm -f $xsess_tmp
        ;;
      *) # Plain sh, ksh, and anything we do not know.
        [ -f /etc/profile ] && . /etc/profile
        [ -f $HOME/.profile ] && . $HOME/.profile
        ;;
    esac

    [ -f /etc/xprofile ] && . /etc/xprofile
    [ -f $HOME/.xprofile ] && . $HOME/.xprofile

    # run all system xinitrc shell scripts.
    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for i in /etc/X11/xinit/xinitrc.d/* ; do
      if [ -x "$i" ]; then
        . "$i"
      fi
      done
    fi

    # Load Xsession scripts
    # OPTIONFILE, USERXSESSION, USERXSESSIONRC and ALTUSERXSESSION are required
    # by the scripts to work
    xsessionddir="${xsessionDir}"
    OPTIONFILE=${xsessionOption}
    USERXSESSION=$HOME/.xsession
    USERXSESSIONRC=$HOME/.xsessionrc
    ALTUSERXSESSION=$HOME/.Xsession

    if [ -d "$xsessionddir" ]; then
        for i in `ls $xsessionddir`; do
            script="$xsessionddir/$i"
            echo "Loading X session script $script"
            if [ -r "$script"  -a -f "$script" ] && expr "$i" : '^[[:alnum:]_-]\+$' > /dev/null; then
                . "$script"
            fi
        done
    fi

    if [ -d /etc/X11/Xresources ]; then
      for i in /etc/X11/Xresources/*; do
        [ -f $i ] && ${pkgs.xorg.xrdb}/bin/xrdb -merge $i
      done
    elif [ -f /etc/X11/Xresources ]; then
      ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresources
    fi
    [ -f $HOME/.Xresources ] && ${pkgs.xorg.xrdb}/bin/xrdb -merge $HOME/.Xresources

    if [ -f "$USERXSESSION" ]; then
      . "$USERXSESSION"
    fi

    if [ -z "$*" ]; then
        exec ${pkgs.xorg.xmessage}/bin/xmessage -center -buttons OK:0 -default OK "Sorry, $DESKTOP_SESSION is no valid session."
    else
        exec $@
    fi
  '';
}
