for file in ./*
do
  if test -d $file
  then
    cd $file
    docker-compose up -d
    cd ..
  fi
done
