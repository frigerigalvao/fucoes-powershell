function checa-pasta
	{
		################################################################################
		# Essa função verifica se um diretório existe e caso não exista o diretório 
		#  será criado. 
        # O Parâmetro -dir é obrigatório e recomendasse que seja sem espaços em branco
        #  ou acentuação
        # O Parâmetro -html é opcional e serve para quando quer que o log seja em HTML
        # O Parâmetro -uppercase é opcional e serve para converter as mensamges de 
        #  saída/log em letras maiúsculas
		#
		#			USO checa-pasta -dir <DIRETORIO> {-html sim} {-uppercase sim}
		#			
		################################################################################
		param   (
                [string]$dir
                [string]$html,
				[string]$uppercase
                )
        if ($dir -eq "")
            {
                $mensagem="Parâmetro -dir faltante"
                $erro=1
            }
        else
            {
                if (!(Test-Path -Path $dir))
		        	{
				        $mensagem="Diretório Criado"
				        New-Item -Path $dir -ItemType Directory -ErrorAction Stop 
			        }
                else
                    {$mensagem="Diretório $dir já existe!"}
            }
        if ($uppercase -eq "sim")
	  		{$mensagem = $mensagem.ToUpper()}
        if ($erro -eq "1")
            {
                if ($html -eq "sim")
                    {
                        Write-Output "<BR>" + $mensagem + "<BR>"
                        exit
                    }
                else
                    {Write-Output $mensagem}
            }
        else
            if ($html -eq "sim")
                {
                    Write-Output "<BR>" + $mensagem + "<BR>"
                    exit
                }
            else
                {Write-Output $mensagem}
	}