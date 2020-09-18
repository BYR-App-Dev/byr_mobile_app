cd "$(dirname "${BASH_SOURCE[0]}")"
>../theme.dart
# theme class
cat theme_class_header.txt >> ../theme.dart
echo >>../theme.dart
echo >>../theme.dart
# each fields
while read p; do
  if [[ "$p" != //* ]]; then
    echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[1]," ",a[2],";"}' >>../theme.dart
  else
    break
  fi
done <theme_fields.txt
echo >>../theme.dart
# default class constructor
echo "BYRTheme(" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print "this.",a[2],","}' >>../theme.dart
  else
    break
  fi
done <theme_fields.txt
echo ");" >>../theme.dart
echo >>../theme.dart
# class constructor generate
echo "BYRTheme.generate({" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print "this.",a[2],","}' >>../theme.dart
  else
    break
  fi
done <theme_fields.txt
echo "});" >>../theme.dart
echo >>../theme.dart
# class inputJson method
echo "static BYRTheme inputJson(Map<String, dynamic> json) {" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    typ=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[1]}')
    name=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[2]}')
    if [[ "$typ" == "Map<String,Color>" ]]; then
      echo "$typ" "$name""Dict" "=" "$typ""();" >>../theme.dart
      echo "for (var c in json['""$name""'].keys) {" >>../theme.dart
      echo "$name""(json['""$name""'][c] != null && Dict[c] = int.tryParse("'"0x"'" + json['""$name""'][c]) != null) ? Color(int.parse("'"0x"'" + json['""$name""'][c])) : null;" >>../theme.dart
      echo "}" >>../theme.dart
    fi
  else
    break
  fi
done <theme_fields.txt
echo "return BYRTheme(" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    typ=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[1]}')
    name=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[2]}')
    if [[ "$typ" == "Color" ]]; then
      echo "(json['"$name"'] != null && int.tryParse('0x' + json['"$name"']) != null) ? Color(int.parse('0x' + json['"$name"'])) : null," >>../theme.dart
    else
      echo "json['""$name""'] as ""$typ""," >>../theme.dart
    fi
  else
    break
  fi
done <theme_fields.txt
echo ");" >>../theme.dart
echo "}" >>../theme.dart
echo >>../theme.dart
# class outputJson method
echo "static Map<String, dynamic> outputJson(BYRTheme instance) {" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    typ=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[1]}')
    name=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[2]}')
    if [[ "$typ" == "Map<String,Color>" ]]; then
      echo "Map<String,String>" "$name""Dict" "=" "Map<String,String>""();" >>../theme.dart
      echo "for (var c in instance.""$name"".keys) {" >>../theme.dart
      echo "$name""Dict[c] = instance.""$name""[c].value.toRadixString(16);" >>../theme.dart
      echo "}" >>../theme.dart
    fi
  else
    break
  fi
done <theme_fields.txt
echo "return <String, dynamic>{" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    typ=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[1]}')
    name=$(echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print a[2]}')
    if [[ "$typ" == "Color" ]]; then
      echo "'""$name""': ""instance.""$name"".value.toRadixString(16)," >>../theme.dart
    else
      echo "'""$name""': ""instance.""$name""," >>../theme.dart
    fi
  else
    break
  fi
done <theme_fields.txt
echo "};" >>../theme.dart
echo "}" >>../theme.dart
echo >>../theme.dart
# class fillBy method
echo "void fillBy(BYRTheme bTheme) {" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print "this.",a[2]," ??= ","bTheme.",a[2],";"}' >>../theme.dart
  else
    break
  fi
done <theme_fields.txt
echo "}" >>../theme.dart
echo >>../theme.dart
# class replaceBy method
echo "void replaceBy(BYRTheme bTheme) {" >>../theme.dart
while read p; do
  if [[ "$p" != //* ]]; then
    echo "$p" | awk 'BEGIN{ OFS = "";}; {split($0,a," "); print "this.",a[2]," = ","bTheme.",a[2]," ?? ","this.",a[2],";"}' >>../theme.dart
  else
    break
  fi
done <theme_fields.txt
echo "}" >>../theme.dart
echo >>../theme.dart
# original themes
cat original_themes.txt >> ../theme.dart
echo >>../theme.dart
# end of class
echo "}" >>../theme.dart
echo >>../theme.dart