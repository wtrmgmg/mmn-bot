# Description:
#   GitHubの最近のコミット履歴を調べ、煽ります。
#

cron = require('cron').CronJob

moment = require('moment-timezone')
moment.tz.setDefault("Asia/Tokyo")

GITHUB_USERS =
  "tkrplus":"@Niwa.Takeru"
  "wtrmgmg":"@Mogi.Wataru"
  "r-manase":"@Masutani.Yuichi"

GITHUB_BASE_URL = "https://api.github.com"
TARGET_ROOM = room: "sandbox"
AORI_MONKU = ["今日は草生やしてないっすけど良いんすか？ｗｗｗｗ",
  "今日は更地ですけど、もしかして芝刈り機にやられちゃいました？？ｗ",
  "となりの芝はあおいっすね〜ｗｗｗｗ",　
  "たまには草生やしてくださいよ〜ぱいせ〜んｗｗｗ",
  "不毛地帯できちゃってますよ〜？？ｗｗｗｗ",
  "草も生えてないとかｗｗｗ大草原不可避ｗｗｗｗｗｗ",
  "今日は生えてないな。お前の頭のように。",
  "草生えないのが許されるのは小学生までだよね〜ｗｗｗｗ",
  "えっ...あなたのContribution Log, もしかして禿げすぎ？"]

module.exports = (robot) ->

  new cron('0 0 22 * * *', () ->
    dateFrom = moment().startOf('day')
    dateTo = moment().endOf('day')
    for user, value of GITHUB_USERS
      checkUserCommits(user)
  ).start()

  robot.respond /github checkCommits (.*)/i, (msg) ->
    user = msg.match[1]
    dateFrom = moment().startOf('day')
    dateTo = moment().endOf('day')
    checkUserCommits(user, dateFrom, dateTo)

  # 指定された期間内にコミットイベント（プッシュイベントがない場合は煽る）
  checkUserCommits = (user, dateFrom, dateTo) ->
    request = robot.http("#{GITHUB_BASE_URL}/users/#{user}/events")
      .get()
    request (err, response, body) ->
      if err
        robot.logger.debug err
        return
      data = JSON.parse body
      commitCount = 0
      for event in data
        unless event.type == "PushEvent"
          continue
        createAt = moment(event.created_at)
        unless dateFrom.IsAfter(createAt) and dateTo.IsBefore(createAt)
          continue
        commitCount++
      if commitCount > 0
        return
      message = AORI_MONKU[random(AORI_MONKU.length)]
      robot.logger.debug user
      robot.logger.debug GITHUB_USERS
      robot.logger.debug GITHUB_USERS[user]
      message = "#{GITHUB_USERS[user]}\n#{message}"
      robot.send TARGET_ROOM, message

  random = (n) -> Math.floor(Math.random() * n)
