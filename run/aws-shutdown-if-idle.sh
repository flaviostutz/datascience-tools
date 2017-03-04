#!/bin/bash

   echo "Verifying if machine is idle"
   date

   #get cpu average usage on the last 1 min
   CPU=$(uptime | awk -F'[a-z]:' '{ print $2}' | awk -F', ' '{print $1 * 100}')

   echo "There are active processes in the queue $CPU (1min avg)"
   if [ $CPU -gt 30 ]; then
      echo "CPU not idle. Canceling shutdown (the chicken has been got!)."
      shutdown -c
   
   else
      echo "CPU idle. Starting chicken game!"

      t=/tmp/ec2.running.seconds.$$
      if wget -q -O $t http://169.254.169.254/latest/meta-data/local-ipv4 ; then
         # add 60 seconds artificially as a safety margin
         let runningSecs=$(( `date +%s` - `date -r $t +%s` ))+60
         rm -f $t
         let runningSecsThisHour=$runningSecs%3600
         let runningMinsThisHour=$runningSecsThisHour/60
         let leftMins=60-$runningMinsThisHour
         # start shutdown one minute earlier than actually required
         let shutdownDelayMins=$leftMins-1
         if [[ $shutdownDelayMins > 1 && $shutdownDelayMins < 60 ]]; then
            echo "Chicken game started! To avoid shutting down, type 'shutdown -c'"
            echo "Shutting down in $shutdownDelayMins mins."
            # TODO: Notify off-instance listener that the game of chicken has begun
            shutdown -h +$shutdownDelayMins
         else
            echo "Shutting down now."
            shutdown -h now
         fi
         exit 0
      fi
      
      echo "Failed to determine remaining minutes in this billable hour. Terminating now."
      shutdown -h now
      exit 1

   fi

