--Pendulum Card Burst
function c511009582.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511009582.cost)
	e1:SetTarget(c511009582.target)
	e1:SetOperation(c511009582.activate)
	c:RegisterEffect(e1)
end
function c511009582.filter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsDestructable(e)
end
function c511009582.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511009582.filter,tp,LOCATION_MZONE,0,2,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c511009582.filter,tp,LOCATION_MZONE,0,2,2,nil,e)
	Duel.Destroy(g,REASON_COST)
end
function c511009582.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c511009582.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
