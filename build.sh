#!/bin/sh

. /auto/share/etc/functions

PROG=${0##*/}

PLUGIN_NAME="fluent-plugin-kubernetes_zebrium"

main() {
    echo "Build Zebrium Fluentd Kubernetes filter plugin"
    gem build $PLUGIN_NAME
    echo "DONE"
}

main "$@"
