export PATH=$PATH:$HOME/.pulumi/bin
source <(pulumi gen-completion zsh)

set_pulumi_context(){
  CONTEXT=$1
  export PULUMI_CONFIG_PASSPHRASE=$(az keyvault secret show --subscription '11cf0077-bfb8-4091-b0ea-74a22e21a53d' --vault-name 'tplat-sre-global-kv' --name "pulumi-stack-passphrase-$CONTEXT" --query='@.value' -o tsv)

  case "$CONTEXT" in
    e2g)
      export AZURE_STORAGE_ACCOUNT="dex2iacstate"
      CONTEXT="dex"
      ;;
    hub|shared|spoke|wan)
      export AZURE_STORAGE_ACCOUNT="olympiacstate"
      ;;
    iris|core|visionai)
      export AZURE_STORAGE_ACCOUNT="${CONTEXT}iacstate"
      ;;
    visionai-hub)
      export AZURE_STORAGE_ACCOUNT="visionaiiacstate"
      ;;
esac
  echo "Using storage account: $AZURE_STORAGE_ACCOUNT"
  export AZURE_STORAGE_KEY=$(az storage account keys list --account-name="$AZURE_STORAGE_ACCOUNT" --subscription='35e7279c-24e1-45c4-87be-a76776a62875' --query='[0].value' -o tsv)
  pulumi login --cloud-url "azblob://pulumi-$CONTEXT-state"
}
