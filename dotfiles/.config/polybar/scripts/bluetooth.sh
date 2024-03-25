if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo "%{F#2E3440}"
  else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
	echo "%{F#D8DEE9}"
fi
  echo "%{T3}%{F#88C0D0}%{T-}"
fi
