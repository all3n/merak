start_gen_compile_flags(){
  cd $APP_DIR
  COMPILE_FLAGS_FILE=$APP_DIR/compile_flags.txt
  echo "-xc++" > $COMPILE_FLAGS_FILE
  INCLUDES=$(find $APP_DIR/deps/install/ -name include -type d)
  for INC in ${INCLUDES[@]};do
    echo "-I" >> $COMPILE_FLAGS_FILE
    echo "$INC" >> $COMPILE_FLAGS_FILE
  done
}
