# Description:
#   mention
#

module.exports = (robot) ->

	robot.hear /@ますたに/i, (msg) -> 
		msg.send "@Masutani.Yuichi "
	
	robot.hear /@もぎ/i, (msg) -> 
		msg.send "@Mogi.Wataru "
	
	robot.hear /@にわ/i, (msg) -> 
		msg.send "@Niwa.Takeru "
