Highscore = {
    kills = 0,
    round = 0
}

function Highscore:addKill()
    self.kills = self.kills + 1
end

function Highscore:nextRound()
    self.round = self.round + 1
end

function Highscore:getKills()
    return self.kills
end

function Highscore:getRound()
    return self.round
end

function Highscore:reset()
    self.kills = 0
    self.round = 0
end