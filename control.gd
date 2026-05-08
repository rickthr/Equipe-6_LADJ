extends Control

@onready var rich_text: RichTextLabel = $"../RichTextLabel"

var textos =[
	"Nós o “Clã dos Antigos Cantos”  mantivemos nossas terras e prosperamos por uma centena de anos, porém, agora com a ascensão do “Clã dos Olhos Divinos”, diversos territórios ao norte vem sido tomados por eles, e parecia questão de tempo até que se interessassem em invadir nosso espaço.",

"Por cem anos cuidamos dessas terras, por cem anos crescemos e conquistamos todos a quem nos opuseram, famílias tão antigas e poderosas quanto nós, exercitos tão formidáveis quanto o nosso, e não serão essas “crianças” que irão nos fazer abaixar a cabeça.",
 
"A guerra entre nossos clãs é apenas questão de tempo… Porém há suspeitas que eles tenham algum tipo de arma secreta, algo tão poderoso que teria sido o motivo por suas grandes vitórias ao norte. Por isso contratamos você, Shinobi. Você foi designado para invadir a grande “Fortaleza de Kami no me”, descobrir os planos de nosso inimigos e destruir sua arma secreta. Nós fomos muito bem informados de sua reputação, não nos decepcione."
	
]
var index = 0
var is_typing = false

func _ready() -> void:
	rich_text.bbcode_enabled = true
	digitar(textos[index])

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		if is_typing:
			rich_text.visible_characters = -1
			is_typing = false
		else:
			index += 1
			if index >= textos.size():
				Global.ir_para_cena("demo_gameplay")
			else:
				digitar(textos[index])

func digitar(texto: String) -> void:
	is_typing = true
	rich_text.text = texto
	rich_text.visible_characters = 0
	
	for i in range(texto.length()):
		if not is_typing:
			break
		rich_text.visible_characters = i + 1
		await get_tree().create_timer(0.05).timeout  # velocidade da digitação
	
	is_typing = false
