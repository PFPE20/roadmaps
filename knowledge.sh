#!/bin/bash

stty -echoctl
trap 'echo -e "\n\t\e[3mSaliendo...\e[0m"; stty echoctl; exit 130' INT

THIS_PATH=$(dirname $( realpath "$0" ) )
DIR_PWN="$THIS_PATH/reverse-engineering"
DIR_NETW="$THIS_PATH/networks-roadmap"


instructions_func() {

  select opt in "INST" "JMP"; do
    case "$opt" in
      "INST")
        cat "$DIR_PWN/$1" | head -n75 | tail -n70 | less; exit
        ;;
      "JMP")
        cat "$DIR_PWN/$1" | head -n113 | tail -n32; exit
        ;;
      *)
        echo -e "\n\t¡Comando desconocido!"
        ;;
    esac
  done
		

}

pwn_func() {

	mapfile -t FFILES < <(ls -1 "$DIR_PWN")
	USEFULL_FILES=("${FFILES[@]}")

	COLUMNS=1
	echo -e "\n\t¿Qué información deseas saber?\n"

	select opt in "${USEFULL_FILES[@]}"; do
		if [[ -n "$opt" ]]; then
      if [[ "$opt" == "INSTRUCTIONS" ]]; then
        instructions_func "$opt"
      else
			  batcat "$DIR_PWN/$opt" -l bash
      fi
		else
			echo -e "\n\t¡Comando desconocido!"
		fi
	done

}

netw_func() {

	mapfile -t FFILES < <(ls -1 "$DIR_NETW")
	USEFULL_FILES=("${FFILES[@]}")

	echo -e "\n\t¿Qué información deseas saber?\n"

	COLUMNS=1
	select opt in "${USEFULL_FILES[@]}"; do
		if [[ -n "$opt" ]]; then
			batcat "$DIR_NETW/$opt" -l bash
		else
			echo -e "\n\t¡Comando desconocido!"
		fi
	done

}


echo -e "\n\tSelecciona una opción para investigar\n"

select opt in "Binarios" "Redes"; do
	case "$opt" in
		"Binarios")
			 pwn_func
			;;
		"Redes")
			netw_func
			;;
		*)
			echo -e "\n\t¡Opción desconocida!"
			;;
	esac
done
