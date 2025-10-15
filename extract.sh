#!/bin/zsh

function usage() {
  echo "Использование: extract [/путь/к/архиву] [/путь/назначения"]
  echo "Распаковывает архив в указанную папку."
  echo "Аргументы:"
  echo "  --help    Показать это сообщение и выйти"
  exit 0
}

if [[ "$1" == "--help" ]]; then
  usage
fi

if [[ $# -ne 2 ]] then
  echo "Недостаточное количество аргументов"
fi

archive="$1"
destination="$2"

if [[ ! -f "$archive" ]] then
  echo "Файла не существует"
  exit 1
fi

mkdir -p "$destination"
ext=${archive##*.}

case $ext in
  zip)
    unzip -qq "$archive" -d "$destination"
    ;;

  tar)
    tar -xf "$archive" -C "$destination"
    ;;

  7z)
    7z x -o"$archive" -y "$destination"
    ;;

  rar)
    unrar x -0+ "$archive" "$destination"
    ;;
  
  gz)
    if [[ "$archive" == *.tar.gz ]]; then
      tar -xzf "$archive" -C "$destination"
    else
      gunzip -c "$archive" > "$destination/${archive:t:r}"
    fi
    ;;
  
  bz2)
    if [[ "$archive" == *.tar.bz2 ]]; then
        tar -xjf "$archive" -C "$destination"
    else
        bunzip2 -c "$archive" > "$destination/${archive:t:r}"
    fi
    ;;

  xz)
    if [[ "$archive" == *.tar.xz ]]; then
      tar -xJf "$archive" -C "$destination"
    else
      unxz -c "$archive" > "$destination/${archive:t:r}"
    fi
    ;;

  *)
    echo "Архив неизвестного формата"
    exit 2 
    ;;
esac

echo "Успешно! Архив распакован в $destination"
