for file in ./*
do
  if test -d $file
  then
    cd $file
    docker-compose down
    cd ..
  fi
done
