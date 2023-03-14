#! /bin/bash

# Autor: Kacper Puda 188625 gr.4
# Utworzono: 29.05.2022
# Ostatnio modyfikowany przez: Kacper Puda
# Data ostatniej modyfikacji: 12.06.2022

# Opis: Program do tworzenia automotycznych kopii zapasowych

# Licensed under GPL (see /usr/share/common-licenses/GPL for more detail
# or contact the Free Software for a copy)

MENU=("Dodaj nową kopie zapasową" "Sprawdz istniejace kopie" "Usun kopie" "Edytuj istniejacą" "Zakoncz")
MENDODAWNIA=("Wybierz plik" "Wybierz katalog" "Wybierz miejsce docelowe" "Podaj date" "Podaj godzine" "Podaj nazwe"  "Zapisz" "Anuluj")
MENDATY=("Konkretna data" "Data własna" "Gotowe")
DNITYG=("każdy" "Poniedziałek" "Wtorek" "Środa" "Czwartek" "Piątek" "Sobota" "Niedziela")

KATSKRYPTU="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

wyciaganieDaty(){

    DZIEN=$( echo $DATA | cut -d "-" -f 1 )
    TMP=$( echo $DZIEN | cut -d "0" -f 2 )
    if [[ -n "$TMP" ]]; then
        DZIEN=$TMP
    fi

    MIESIAC=$( echo $DATA | cut -d "-" -f 2 )
    TMP=$( echo $MIESIAC | cut -d "0" -f 2 )
    if [[ -n "$TMP" ]]; then
      MIESIAC=$TMP
    fi

    ROK=$( echo $DATA | cut -d "-" -f 3 )

}


ustawianieDaty(){

    if [[ $DZIEN = "*/1" ]]; then 
        DZIEN="*"
        DATA="$DZIEN*"
    elif [[ ${#DZIEN} = 1 ]]; then
        DATA="0$DZIEN"
    else 
        DATA="$DZIEN"
    fi

    if [[ $MIESIAC = "*/1" ]]; then 
        MIESIAC="*"
        DATA="$DATA-$MIESIAC*"
    elif [[ ${#MIESIAC} = 1 ]]; then
        DATA="$DATA-0$MIESIAC"
    else 
        DATA="$DATA-$MIESIAC"
    fi

    if [[ $DZIENTYG = "Każdy" ]]; then 
        DZIENTYG="*"
        DATA="$DATA-$DZIENTYG*"
    else 
        DATA="$DATA-$DZIENTYG"
    fi

    if [[ $DZIENTYG = "Poniedziałek" ]]; then
        DZIENTYG=1
    elif [[ $DZIENTYG = "Wtorek" ]]; then
        DZIENTYG=2 
    elif [[ $DZIENTYG = "Środa" ]]; then
        DZIENTYG=3 
    elif [[ $DZIENTYG = "Czwartek" ]]; then
        DZIENTYG=4 
    elif [[ $DZIENTYG = "Piątek" ]]; then
        DZIENTYG=5 
    elif [[ $DZIENTYG = "Sobota" ]]; then
        DZIENTYG=6 
    elif [[ $DZIENTYG = "Niedziela" ]]; then
        DZIENTYG=7 
    fi

}


podawanieDaty(){

        WYJSCIE=`zenity --forms --title="Podaj date" --text="Podaj date" --separator=","\
        --add-combo="Rodzaj" --combo-values="Co ileś dni|W konkretnym dniu" \
        --add-combo="Dzień" --combo-values="1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31"\
        --add-combo="Rodzaj" --combo-values="Co ileś miesięcy|W konkretnym miesiącu" \
        --add-combo="Miesiąc" --combo-values="1|2|3|4|5|6|7|8|9|10|11|12"\
        --add-combo="Dzień tygodnia" --combo-values="Każdy|Poniedziałek|Wtorek|Środa|Czwartek|Piątek|Sobota|Niedziela" `

        RODZAJDNIA="$( echo "$WYJSCIE" | cut -d "," -f 1 )"
        DZIEN="$( echo "$WYJSCIE" | cut -d "," -f 2 )"
        if [[ "$RODZAJDNIA" = "Co ileś dni" ]]; then
            DZIEN="*/$DZIEN"
        fi
        RODZAJMIESIACA="$( echo "$WYJSCIE" | cut -d "," -f 3 )"
        MIESIAC="$( echo "$WYJSCIE" | cut -d "," -f 4 )"
        if [[ "$RODZAJMIESIACA" = "Co ileś miesięcy" ]]; then
            MIESIAC="*/$MIESIAC"
        fi
        DZIENTYG="$( echo "$WYJSCIE" | cut -d "," -f 5 )"
        ustawianieDaty

}


godzina(){
    
     RODZAJMINUTY=`zenity --forms --title="Rodzaj minut" --text="Jak wykonywać minuty?" --add-combo="Rodzaj" --combo-values="Co ileś minut|O konkretnej minucie"`
     if [[ "$RODZAJMINUTY" = "Co ileś minut" ]]; then
        MINUTA=`zenity --scale --title "Minuty" --text "Podaj minute" --min-value 1 --max-value 59 --value 1`
        MINUTA="*/$MINUTA"
     else 
        MINUTA=`zenity --scale --title "Minuty" --text "Podaj minute" --min-value 0 --max-value 59 --value 0`
     fi
     RODZAJGODZINY=`zenity --forms --title="Rodzaj godziny" --text="Jak wykonywać godziny?" --add-combo="Rodzaj" --combo-values="Co ileś godzin|O konkretnej godzine"`
     if [[ "$RODZAJGODZINY" = "Co ileś godzin" ]]; then
        GODZINA=`zenity --scale --title "Godzina" --text "Podaj godzine" --min-value 1 --max-value 23 --value 1`
        GODZINA="*/$GODZINA"
     else
        GODZINA=`zenity --scale --title "Godzine" --text "Podaj godzie" --min-value 0 --max-value 23 --value 0`
     fi

    if [[ $MINUTA = "*/1" ]]; then
        PELNAGODZINA="**"
        MINUTA="*"
    elif [[ ${#MINUTA} = 1 ]]; then
        PELNAGODZINA="0$MINUTA"
    else 
        PELNAGODZINA="$MINUTA"
    fi
    
    if [[ $GODZINA = "*/1" ]]; then
        PELNAGODZINA="**:$PELNAGODZINA"
        GODZINA="*"
    elif [[ ${#GODZINA} = 1 ]]; then
        PELNAGODZINA="0$GODZINA:$PELNAGODZINA"
    else 
        PELNAGODZINA="$GODZINA:$PELNAGODZINA"
    fi

}


tworzenieSkryptu(){

    if [[ "$NAZWA" != "$NAZWAEDYCJI" ]]; then
        ERR=$( mkdir "$GDZIEKOPIUJE/$NAZWA" 2>&1 )
        if [[ -n "$ERR" ]]; then 
            return
        fi  
    fi

    if [[ $1 -eq 2 ]]; then
        rm $KATSKRYPTU/skrypty/$IDEDYCJI.sh
    fi

    SCIEZKA="$GDZIEKOPIUJE/$NAZWA"
    echo "#! /bin/bash" > $KATSKRYPTU/skrypty/$IDKOPII.sh
    echo "rm -rf $SCIEZKA/*" >> $KATSKRYPTU/skrypty/$IDKOPII.sh
    echo "cp -r $COKOPIUJE $SCIEZKA" >> $KATSKRYPTU/skrypty/$IDKOPII.sh
    chmod 764 $KATSKRYPTU/skrypty/$IDKOPII.sh

}


tworzenieKopii(){

    FILETEMP=$( mktemp );
    IDKOPII=$( echo "$FILETEMP" | cut -d "." -f 2 )
    rm $FILETEMP
    tworzenieSkryptu $1

    if [[ -n "$ERR" ]]; then 
        return
    fi

    echo "$NAZWA;$IDKOPII;$COKOPIUJE;$GDZIEKOPIUJE;$DATA;$PELNAGODZINA;$MINUTA;$GODZINA;$DZIEN;$MIESIAC;$DZIENTYG" >> $KATSKRYPTU/kopie/wszystkieKopie.txt

    SCIEZKA="./../../$KATSKRYPTU/skrypty/$IDKOPII.sh"
    CRON="$MINUTA $GODZINA $DZIEN $MIESIAC $DZIENTYG $SCIEZKA" 
    CR=$( crontab -l 2>&1 );

    if [[ -z "$(echo "$CR" | grep "/" )" ]]; then
        echo "$CRON #$IDKOPII" | crontab
    else 
        ( echo "$CR"; echo "$CRON #$IDKOPII" ) | crontab
    fi

}


dodawanie(){

    if [[ $1 -eq 1 ]]; then
        COKOPIUJE=""
        GDZIEKOPIUJE=""
        NAZWA=""
        MINUTA=""
        GODZINA=""
        DZIEN=""
        MIESIAC=""
        DZIENTYG=""
        DATA=""
        PELNAGODZINA=""
    fi

    while [ true ]; do

        INFO="Nazwa kopii: $NAZWA \nCo mam kopiowac: $COKOPIUJE \nGdzie mam kopiowac: $GDZIEKOPIUJE \nData: $DATA $PELNAGODZINA"
        ODP=`zenity --list --text="$INFO" --column=Menu "${MENDODAWNIA[@]}" --height 350 --width 400 --title="Dodaj nową kopie zapasową"`

        case "$ODP" in

            "${MENDODAWNIA[0]}" )
                COKOPIUJE=`zenity --file-selection`
                ER=$( echo "$COKOPIUJE" | grep " " )
                if [[ -n "$ER" ]]; then
                    COKOPIUJE=""
                    zenity --warning --title "Błąd" --text "Błedna nazwa pliku. Nazwa nie może zawierać spacji"
                    continue
                fi
            ;;

            "${MENDODAWNIA[1]}" )
                COKOPIUJE=`zenity --file-selection --directory`
                COKOPIUJE="$COKOPIUJE/"
            ;;
            
            "${MENDODAWNIA[2]}" )
                GDZIEKOPIUJE=`zenity --file-selection --directory`
            ;;

            "${MENDODAWNIA[3]}" )
                    podawanieDaty
            ;;

            "${MENDODAWNIA[4]}" )
                godzina
            ;;

            "${MENDODAWNIA[5]}" )
                NAZWADOSPRAWDZENIA=`zenity --entry --title "Nazwa kopii" --text "Podaj nazwe kopii:"`
                NAZWADOSPRAWDZENIA=$(echo "$NAZWADOSPRAWDZENIA" | tr " " "_")
                if [[ -z $( grep "^$NAZWADOSPRAWDZENIA;" $KATSKRYPTU/kopie/wszystkieKopie.txt ) ]]; then
                    
                    NAZWA=$NAZWADOSPRAWDZENIA
                else 
                    if [[ $1 -eq 2 ]]; then
                        if [[ "$NAZWADOSPRAWDZENIA" = "$NAZWAEDYCJI" ]]; then
                            NAZWA="$NAZWADOSPRAWDZENIA"
                            continue
                        fi    
                    fi
                    zenity --warning --title "Błąd" --text "Nazwa zajęta"
                fi  
            ;;

            "${MENDODAWNIA[6]}" )
                if [[ -z "$COKOPIUJE" ]]; then 
                   zenity --warning --title "Błąd" --text "Podaj co chcesz kopiować"  
                elif [[ -z "$GDZIEKOPIUJE" ]]; then
                   zenity --warning --title "Błąd" --text "Podaj miejsce docelowe"  
                elif [[ -z "$DZIEN" ]]; then
                   zenity --warning --title "Błąd" --text "Nie podano dnia"  
                elif [[ -z "$MIESIAC" ]]; then
                   zenity --warning --title "Błąd" --text "Nie podano miesiąca"  
                elif [[ -z "$DZIENTYG" ]]; then
                   zenity --warning --title "Błąd" --text "Nie podano roku"  
                elif [[ -z "$MINUTA" ]]; then
                   zenity --warning --title "Błąd" --text "Nie podano minuty"  
                elif [[ -z "$GODZINA" ]]; then
                   zenity --warning --title "Błąd" --text "Nie podano godziny"  
                elif [[ -z "$NAZWA" ]]; then
                   zenity --warning --title "Błąd" --text "Podaj nazwę kopii"  
                else 
                   if [[ $1 -eq 1 ]]; then
                            ERR=$(find "$GDZIEKOPIUJE" -name "$NAZWA" -type d)
                       if [[ -n "$ERR" ]]; then
                           zenity --warning --title "Błąd" --text "W miejscu docelowym isnieje folder o nazwie $NAZWA"  
                           continue   
                       fi
                       tworzenieKopii $1
                       if [[ -n "$ERR" ]]; then 
                           zenity --warning --title "Błąd" --text "Błąd przy tworzeniu kopii"
                           break   
                       else 
                           zenity --info --title "Gratulacje!" --text "Kopia stworzona"
                           break
                       fi
                    else
                       if [[ "$NAZWA" != "$NAZWAEDYCJI" ]]; then
                             ERR=$( find "$GDZIEKOPIUJE" -name "$NAZWA" -type d )
                               if [[ -n "$ERR" ]]; then
                                   zenity --warning --title "Błąd" --text "W miejscu docelowym isnieje folder o nazwie $NAZWA"  
                                   continue   
                               fi
                       fi
                       grep ";$IDEDYCJI;" -v $KATSKRYPTU/kopie/wszystkieKopie.txt > $KATSKRYPTU/kopie/zbiortmp.txt
                       cat $KATSKRYPTU/kopie/zbiortmp.txt > $KATSKRYPTU/kopie/wszystkieKopie.txt
                       ( crontab -l | grep "$IDEDYCJI" -v ) | crontab
                       tworzenieKopii $1
                       if [[ -n "$ERR" ]]; then 
                           zenity --warning --title "Błąd" --text "Błąd przy tworzeniu kopii"
                           break   
                       else 
                           zenity --info --title "Gratulacje!" --text "Kopia zapisana"
                           break
                       fi
                    
                    fi
                        
                fi ;;   

            "${MENDODAWNIA[7]}" ) break;
        esac

    done

}


edycja(){

     while [ true ]; do

        MENUEDYCJI=()
        i=0
        MENUEDYCJI[0]="Anuluj"
        for NAZWA in $( cut -d ";" -f 1 $KATSKRYPTU/kopie/wszystkieKopie.txt ); do
            MENUEDYCJI[i]=$NAZWA
            i=$(($i+1))
        done
        MENUEDYCJI[i]="Anuluj"

        ODP=`zenity --list --text="Wybierz kopie ktore chcesz edytowac" --column=Menu "${MENUEDYCJI[@]}" --height 350 --width 400 --title="Edycja kopii"`

        if [[ $ODP = "Anuluj" ]]; then
            break
        elif [[ -n "$ODP" ]]; then
            MINUTA=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 7 )
            GODZINA=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 8 )
            DZIEN=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 9 )
            MIESIAC=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 10 )
            DZIENTYG=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 11 )
            DATA=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 5 )
            PELNAGODZINA=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 6 )
            NAZWAEDYCJI=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 1 )
            NAZWA="$NAZWAEDYCJI"
            IDEDYCJI=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 2 )
            GDZIEKOPIUJE=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 4 )
            COKOPIUJE=$( grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 3 )
            dodawanie 2
        else 
            break
        fi
        done

}


usuwanie(){

     while [ true ]; do

        MENUUSUWANIA=()
        i=0
        MENUUSUWANIA[0]="Anuluj"
        for NAZWA in $( cut -d ";" -f 1 $KATSKRYPTU/kopie/wszystkieKopie.txt ); do
            MENUUSUWANIA[i]=$NAZWA
            i=$(( $i + 1 ))
        done
        MENUUSUWANIA[i]="Anuluj"

        ODP=`zenity --list --text="Wybierz kopie ktore chcesz usunać" --column=Menu "${MENUUSUWANIA[@]}" --height 350 --width 400 --title="Usuwanie kopii"`

        if [[ $ODP = "Anuluj" ]]; then
            break
        elif [[ -n "$ODP" ]]; then
            ID=$(grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 2)
            KATALOG=$(grep "^$ODP" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 4)
            rm -rf "$KATALOG/$ODP"
            grep ";$ID;" -v $KATSKRYPTU/kopie/wszystkieKopie.txt > $KATSKRYPTU/kopie/zbiortmp.txt
            cat $KATSKRYPTU/kopie/zbiortmp.txt > $KATSKRYPTU/kopie/wszystkieKopie.txt
            ( crontab -l | grep "#$ID" -v ) | crontab
            rm skrypty/$ID.sh
        fi
        done

}


while getopts kvf: OPT; do
 case $OPT in
   k) 
    cut -d ";" -f 1 $KATSKRYPTU/kopie/wszystkieKopie.txt
    exit;;
   v) 
    echo "wersja 1.0" 
    exit ;;
   f) 
    NAZWAPLIKU=$OPTARG
    COROBI=$( grep "^$NAZWAPLIKU;" $KATSKRYPTU/kopie/wszystkieKopie.txt | cut -d ";" -f 3 )
    if [[ -z "$COROBI" ]]; then
        echo "Nie ma takiej kopii"
    else
        echo "$COROBI"
    fi
    exit;;
   *) echo "nieznana opcja" 
    exit ;;
 esac
done


while [ true ]; do
    ODP=`zenity --list --column=Menu "${MENU[@]}" --height 350 --width 400 --title="Kopie Zapasowe"`
    case "$ODP" in
    "${MENU[0]}" ) dodawanie 1;;
    "${MENU[1]}" ) zenity --info --title "Istniejące kopie" --text "$( cut -d ";" -f 1,3,4,5,6 $KATSKRYPTU/kopie/wszystkieKopie.txt | sed 's/;/:  /' | sed 's/;/  -->  /' | sed 's/;/   /g' )" --height 350 --width 650 ;;
    "${MENU[2]}" ) usuwanie ;;
    "${MENU[3]}" ) edycja;;
    "${MENU[4]}" ) break;;
    esac
done
 
