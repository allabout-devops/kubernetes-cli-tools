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


