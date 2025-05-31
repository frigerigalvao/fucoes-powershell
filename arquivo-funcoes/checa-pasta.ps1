<#
.SYNOPSIS
    Gerencia a criação de diretórios e fornece feedback sobre a operação.

.DESCRIPTION
    Este cmdlet verifica a existência de um diretório e o cria se ele não existir.
    Ele fornece mensagens de status formatadas em HTML ou texto plano,
    e pode converter a mensagem para maiúsculas.

.PARAMETER Dir
    O caminho completo do diretório a ser verificado ou criado. Este parâmetro é obrigatório.
    Sua ausência resultará em uma interrupção terminante da execução.

.PARAMETER AsHtml
    Se presente, a mensagem de saída será formatada com tags HTML.

.PARAMETER AsUppercase
    Se presente, a mensagem de saída será convertida para letras maiúsculas.

.EXAMPLE
    checa-pasta -Dir "C:\MeusDados\NovoDiretorio"
    # Tenta criar "C:\MeusDados\NovoDiretorio". Exibe "Diretório 'C:\MeusDados\NovoDiretorio' criado com sucesso!" ou "Diretório 'C:\MeusDados\NovoDiretorio' já existe."

.EXAMPLE
    checa-pasta -Dir "C:\Relatorios" -AsHtml
    # Tenta criar "C:\Relatorios". Exibe a mensagem formatada em HTML.

.EXAMPLE
    checa-pasta -Dir "C:\Temp\Uploads" -AsUppercase -AsHtml
    # Tenta criar "C:\Temp\Uploads". Exibe a mensagem em maiúsculas e formatada em HTML.

.EXAMPLE
    checa-pasta # Exemplo de erro: a ausência do parâmetro '-Dir' causará uma interrupção terminante.

.NOTES
    Desenvolvido por Flavio Galvão
    Versão: 1.2
    Data: 2025-05-30
    Licença: MIT Lincese
#>
Function checa-pasta 
		{
			[CmdletBinding()]
			[OutputType([string])]
			param 
				(
					[Parameter(Mandatory=$true, HelpMessage="Especifique o caminho completo do diretório.")]
					[string]$Dir,
					[switch]$AsHtml,
					[switch]$AsUppercase
				)
			# Variável para armazenar a mensagem final
			$message = ""
		
			try 
				{
					# Verifica se o diretório existe
					if (-not (Test-Path -Path $Dir)) 
						{
							$message = "Diretório '$Dir' criado com sucesso!"
							# Tenta criar o diretório. Se houver erro (ex: permissões), será capturado pelo bloco catch.
							New-Item -Path $Dir -ItemType Directory -ErrorAction Stop
						} 
					else 
						{$message = "Diretório '$Dir' já existe."}
				}
			catch 
				{
					# Captura e trata qualquer erro durante a criação/verificação do diretório
					# Prepara a mensagem de erro.
					$errorMessage = "Erro ao processar o diretório '$Dir': $($_.Exception.Message)"
					# Aplica a formatação de maiúsculas À MENSAGEM DE ERRO se o switch -AsUppercase estiver presente
					if ($AsUppercase) 
						{$errorMessage = $errorMessage.ToUpper()}
					# Reporta o erro usando Write-Error, permitindo que seja tratado por chamadores.
					Write-Error -Message $errorMessage -Category WriteError
					# Lança a exceção original para garantir a interrupção do chamador APENAS NESTE CASO DE ERRO DE EXECUÇÃO
					# Isso é o que fará com que o script/chamador pare, a menos que ele tenha um try/catch.
					throw $_ # Relança a exceção original ($_) para preservar detalhes do erro
				}
			# Aplica a formatação de maiúsculas às mensagens de sucesso/existência
			# (Isso só será executado se não houver um erro capturado no bloco try/catch)
			if ($AsUppercase) 
				{$message = $message.ToUpper()}
			# Define o método de saída (HTML ou texto plano)
			if ($AsHtml) 
				{Write-Output "<BR>$message<BR>"}
			else 
				{Write-Output $message}
		}