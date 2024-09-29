To use these functions copy  required function from kubernetes.sh file in ~/.bashrc or ~/.zshrc file 

Use kgp to list pods with filters in current namespace or specific namespace using flag -n <namespace_name>

Example 
##
        kgp test                # List all pod in current namespace and filter with test word
        kgp -n test             # List all pods in test namespace
        kgp nginx test -n test  # List all pods in test namespace and filter with words test or nginx 

Use kns to play with namesapces 

Example 

##
        kns         # List all namespaces with index number 
        kns test    # Switch to test namespace

