#!/bin/sh

BASEDIR="`dirname $0`/.."

FULLVER="$1"

case $FULLVER in
  2.10.2)
    VER=2.10
    ;;
  2.11.7)
    VER=2.11
    ;;
  2.12.0-M3)
    VER=2.12.0-M3
    ;;
  2.10.3|2.10.4|2.10.5|2.10.6|2.11.0|2.11.1|2.11.2|2.11.4|2.11.5|2.11.6)
    echo "Ignoring checksizes for Scala $FULLVER"
    exit 0
    ;;
esac

REVERSI_PREOPT="$BASEDIR/examples/reversi/target/scala-$VER/reversi-fastopt.js"
REVERSI_OPT="$BASEDIR/examples/reversi/target/scala-$VER/reversi-opt.js"

REVERSI_PREOPT_SIZE=$(stat '-c%s' "$REVERSI_PREOPT")
REVERSI_OPT_SIZE=$(stat '-c%s' "$REVERSI_OPT")

gzip -c "$REVERSI_PREOPT" > "$REVERSI_PREOPT.gz"
gzip -c "$REVERSI_OPT" > "$REVERSI_OPT.gz"

REVERSI_PREOPT_GZ_SIZE=$(stat '-c%s' "$REVERSI_PREOPT.gz")
REVERSI_OPT_GZ_SIZE=$(stat '-c%s' "$REVERSI_OPT.gz")

case $FULLVER in
  2.10.2)
    REVERSI_PREOPT_EXPECTEDSIZE=680000
    REVERSI_OPT_EXPECTEDSIZE=161000
    REVERSI_PREOPT_GZ_EXPECTEDSIZE=92000
    REVERSI_OPT_GZ_EXPECTEDSIZE=44000
    ;;
  2.11.7)
    REVERSI_PREOPT_EXPECTEDSIZE=621000
    REVERSI_OPT_EXPECTEDSIZE=153000
    REVERSI_PREOPT_GZ_EXPECTEDSIZE=86000
    REVERSI_OPT_GZ_EXPECTEDSIZE=41000
    ;;
  2.12.0-M3)
    REVERSI_PREOPT_EXPECTEDSIZE=616000
    REVERSI_OPT_EXPECTEDSIZE=152000
    REVERSI_PREOPT_GZ_EXPECTEDSIZE=86000
    REVERSI_OPT_GZ_EXPECTEDSIZE=41000
    ;;
esac

echo "Checksizes: Scala version: $FULLVER"
echo "Reversi preopt size = $REVERSI_PREOPT_SIZE (expected $REVERSI_PREOPT_EXPECTEDSIZE)"
echo "Reversi opt size = $REVERSI_OPT_SIZE (expected $REVERSI_OPT_EXPECTEDSIZE)"
echo "Reversi preopt gzip size = $REVERSI_PREOPT_GZ_SIZE (expected $REVERSI_PREOPT_GZ_EXPECTEDSIZE)"
echo "Reversi opt gzip size = $REVERSI_OPT_GZ_SIZE (expected $REVERSI_OPT_GZ_EXPECTEDSIZE)"

[ "$REVERSI_PREOPT_SIZE" -le "$REVERSI_PREOPT_EXPECTEDSIZE" ] && \
  [ "$REVERSI_OPT_SIZE" -le "$REVERSI_OPT_EXPECTEDSIZE" ] && \
  [ "$REVERSI_PREOPT_GZ_SIZE" -le "$REVERSI_PREOPT_GZ_EXPECTEDSIZE" ] && \
  [ "$REVERSI_OPT_GZ_SIZE" -le "$REVERSI_OPT_GZ_EXPECTEDSIZE" ]
