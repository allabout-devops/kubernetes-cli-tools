COLOR_RESET="\033[0m"
COLOR_BLACK="\033[0;30m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"
COLOR_CYAN="\033[0;36m"
COLOR_WHITE="\033[0;37m"
COLOR_BOLD_BLACK="\033[1;30m"
COLOR_BOLD_RED="\033[1;31m"
COLOR_BOLD_GREEN="\033[1;32m"
COLOR_BOLD_YELLOW="\033[1;33m"
COLOR_BOLD_BLUE="\033[1;34m"
COLOR_BOLD_MAGENTA="\033[1;35m"
COLOR_BOLD_CYAN="\033[1;36m"
COLOR_BOLD_WHITE="\033[1;37m"


alias k=kubectl

# List all pods in current namespace or specify namespace with flag -n and filter with multiple argument 
kgp() {
  local namespace=""
  local filters=()

  # Iterate through all arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -n) namespace="$2"; shift 2 ;;  # Capture namespace
      *) filters+=("$1"); shift ;;      # Capture filter arguments
    esac
  done

  # Create the grep pattern for filtering
  if [[ ${#filters[@]} -gt 0 ]]; then
    grep_pattern=$(IFS=\|; echo "${filters[*]}")  # Join filters with |
  else
    grep_pattern=".*"  # Match everything if no filters provided
  fi

  # List pods based on the namespace and filter
  if [[ -n "$namespace" ]]; then
    kubectl get pods -n "$namespace" | grep -E "$grep_pattern"
  else
    kubectl get pods | grep -E "$grep_pattern"
  fi
}

kns() {

  # Get the list of namespaces
  local namespaces=($(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'))
  local current_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}')
  current_ns=${current_ns:-"default"}  # Default to "default" if no namespace is set

  if [ "$1" ]; then
    # Check if the argument is a valid index
    if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -lt "${#namespaces[@]}" ]; then
      kubectl config set-context --current --namespace="${namespaces[$1]}"
      echo -e "${COLOR_GREEN}Switched to namespace: ${namespaces[$1]}${COLOR_RESET}"
    else
      echo -e "${COLOR_YELLOW}Invalid index. Please provide a number between 0 and $((${#namespaces[@]} - 1)).${COLOR_RESET}"
    fi
  else
    echo -e "${COLOR_YELLOW}Available namespaces:${COLOR_RESET}"
    for i in "${!namespaces[@]}"; do
      if [ "${namespaces[$i]}" == "$current_ns" ]; then
        echo -e "$i: ${COLOR_BOLD_BLUE}${namespaces[$i]}${COLOR_RESET}"  # Highlight current namespace
      else
        echo "$i: ${namespaces[$i]}"
      fi
    done
  fi
}




