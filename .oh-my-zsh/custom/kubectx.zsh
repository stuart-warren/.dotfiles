[[ -n $DEBUG ]] && set -x

#
# Vars.
kube_config_dir=$HOME/.kube/config.d
export KUBECONFIG_ORIG=${KUBECONFIG:-"${HOME}/.kube/config"}


#
# Usage.
kubech() {
  cat <<EOF
NOTE:
  - The command "kubech" is just a meta for other commands. So kubech does nothing by itself.
  - Short names "kchc/kchn" also available.

USAGE:
  kubechc             : List all contexts
  kubechc <CONTEXT>   : Switch to context <CONTEXT>
  kubechn             : List all namespaces
  kubechn <NAMESPACE> : Switch to namespace <NAMESPACE>
EOF
}


#
# General.
if ! [[ -d ${kube_config_dir} ]]; then
    mkdir -p ${kube_config_dir}
fi


#
# Generate kubectl config for a single context.
_kubechg () {
	[[ -n $DEBUG ]] && set -x
    kube_context=${1}
    kube_namespace=${2:-default}
    kube_config_file="${kube_context}-${kube_namespace}"
    KUBECONFIG="${KUBECONFIG:-${HOME}/.kube/config}"

    kubectl config view            \
        --minify                   \
        --flatten                  \
        --context=${kube_context}  \
		-o json |
		jq --arg ns "${kube_namespace}" '.["current-context"] as $cc | .contexts |= map(select(.name == $cc) | .context.namespace |= $ns)' > ${kube_config_dir}/${kube_config_file}
}


#
# Change kubectl context.
kubechc () {
    kube_context=${1}
    kube_namespace=${2:-default}
    kube_config_file="${kube_context}-${kube_namespace}"

    if [[ -n ${kube_context} ]]; then
        _kubechg ${kube_context} ${kube_namespace}
        export KUBECONFIG="${kube_config_dir}/${kube_config_file}:${KUBECONFIG_ORIG}"
        kubectl config use-context ${kube_context}
        k8s-login "${1}"
    else
        kubechc $(kubectl config get-contexts --no-headers=true -o name | fzf)
    fi
}

alias ct='kubechc'

#
# Change kubectl namespace
kubechn () {
    kube_namespace=${1:-default}
    kube_namespace_all=$(kubectl get namespaces -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

    if [[ -n ${1} ]]; then
        # Only switch namespace if it exists.
        if [[ $(echo "${kube_namespace_all}" | egrep "^${kube_namespace}$") ]]; then
            kubechc $(kubectl config current-context) ${kube_namespace}
            echo "Switched to namespace \"${kube_namespace}\""
        else
            echo "The namespace \"${kube_namespace}\" doesn't exist"
        fi
    else
        kubechn $(echo "${kube_namespace_all}" | fzf)
    fi
}

alias ns='kubechn'


# export KUBECTXTTYCONFIG="${HOME}/.kube/tty/$(basename $(tty) 2>/dev/null || echo 'notty')"
# mkdir -p "$(dirname $KUBECTXTTYCONFIG)"
# export KUBECONFIG="${KUBECTXTTYCONFIG}:${KUBECONFIG}"
# cat <<EOF >${KUBECTXTTYCONFIG}
# apiVersion: v1
# kind: Config
# current-context: "docker-desktop"
# EOF


# ct() {
# 	kubectx $*
# 	kubectl --context="$(kubectl --kubeconfig $KUBECTXTTYCONFIG config current-context)" config view --raw --minify -o json | jq 'del(.users,.clusters)' >$KUBECTXTTYCONFIG
# }

_fzf_complete_ct() {
	_fzf_complete "+m --ansi --no-preview" "$@" < <(
		KUBECTX_IGNORE_FZF=true kubechc
	)
}

# alias ns="kubens"

_fzf_complete_ns() {
	_fzf_complete "+m --ansi --no-preview" "$@" < <(
		KUBECTX_IGNORE_FZF=true kubechn
	)
}
