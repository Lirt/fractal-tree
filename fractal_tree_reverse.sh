#!/bin/bash

read -r N

# Columns
Y=100
# Current Length
L=32

half=100
half=$((half / 2 - 1))

declare -A visited

for (( n = 0; n < N; n++ )); do

  # Halve the length
  L=$(( L / 2 ))

  # Do vertical part
  for (( i = 0 ; i < L; i++)); do
    for (( j = 0 ; j < Y; j++)); do
      if [ ${#visited[@]} -eq 0 ]; then
        if (( j % half == 0 )) && (( j != 0 )) && (( j != 98 )); then
          out+="1"
        else
          out+="_"
        fi
      else
        one=0
        for k in "${!visited[@]}"; do
          if (( j == k - L_prev )) || (( j == k + L_prev )); then
            out+="1"
            one=1
          fi
        done
        [ $one -eq 0 ] && out+="_"
      fi
    done
    out+=$'\n'
  done


  # Update visited columns
  if [ ${#visited[@]} -eq 0 ]; then
    visited["$half"]=1
  else
    for k in "${!visited[@]}"; do
      unset visited["$k"]
      id_l=$((k - L_prev))
      id_r=$((k + L_prev))
      visited["$id_l"]=1
      visited["$id_r"]=1
    done
  fi


  # Do skewed part
  for (( i = 1 ; i <= L; i++)); do
    for (( j = 0 ; j < Y; j++)); do
      one=0
      for k in "${!visited[@]}"; do
        offset_left=$((k - i))
        offset_right=$((k + i))

        if (( j == offset_left )) || (( j == offset_right )); then
          out+="1"
          one=1
        fi
      done
      [ $one -eq 0 ] && out+="_"
    done
    out+=$'\n'
  done

  # Save previous length
  L_prev=$L

done

for ((i = 0; i < 2 * ( 2 ** (5-N) ) - 1; i++ )); do
  for ((j = 0; j < Y; j++)); do
    out+="_"
  done
  out+=$'\n'
done

echo -n "$out" | tac
