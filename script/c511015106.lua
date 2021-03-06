--Odd-Eyes Xyz Gate
function c511015106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511015106.cost)
	e1:SetTarget(c511015106.target)
	e1:SetOperation(c511015106.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(511015106,ACTIVITY_SPSUMMON,c511015106.counterfilter)
end
function c511015106.counterfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c511015106.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c511015106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(511015106,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c511015106.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c511015106.filter1(c,e,tp)
	return c:IsCode(16178681) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingTarget(c511015106.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c511015106.filter2(c,e,tp,odd)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c511015106.filter3,tp,LOCATION_EXTRA,0,1,odd,e,tp,c,odd)
end
function c511015106.filter3(c,e,tp,xyz,odd)
	if not c:IsType(TYPE_XYZ) or not c:IsType(TYPE_PENDULUM) then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetValue(7)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	xyz:RegisterEffect(e1)
	local result=c:IsXyzSummonable(Group.FromCards(xyz,odd),2,2)
	e1:Reset()
	return result
end
function c511015106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and (not ect or ect>=2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.GetLocationCountFromEx(tp)>0 and Duel.GetUsableMZoneCount(tp)>1 
		and Duel.IsExistingTarget(c511015106.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c1=Duel.SelectTarget(tp,c511015106.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c2=Duel.SelectTarget(tp,c511015106.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c1):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Group:FromCards(c1,c2),2,0,0)
end
function c511015106.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		or Duel.GetLocationCountFromEx(tp)<=0 or Duel.GetUsableMZoneCount(tp)<=1 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_XYZ) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_RANK_LEVEL_S)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(7)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(function(sc) return sc:IsType(TYPE_PENDULUM) and sc:IsType(TYPE_XYZ) and sc:IsXyzSummonable(sg,2,2) end,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=g:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg)
		if not c:IsRelateToEffect(e) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		xyz:RegisterFlagEffect(511015106,RESET_EVENT+0x1fe0000,0,0)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(TIMING_DAMAGE_STEP)
		e1:SetCondition(c511015106.atkcon)
		e1:SetCost(c511015106.atkcost)
		e1:SetTarget(c511015106.atktg)
		e1:SetOperation(c511015106.atkop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabelObject(xyz)
		c:RegisterEffect(e1)
	end
end
function c511015106.atkcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp and bit.band(Duel.GetCurrentPhase(),0x38)~=0 
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c511015106.costfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c511015106.atkcost(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c511015106.costfilter,tp,LOCATION_GRAVE,0,1,nil,511015104)
		and Duel.IsExistingMatchingCard(c511015106.costfilter,tp,LOCATION_GRAVE,0,1,nil,511015105) end
	local g1=Duel.SelectMatchingCard(tp,c511015106.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,511015104)
	g1:Merge(Duel.SelectMatchingCard(tp,c511015106.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,511015105))
	g1:AddCard(e:GetHandler())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c511015106.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and tc:IsLocation(LOCATION_MZONE) and tc:GetFlagEffect(511015106)>0 end
	Duel.SetTargetCard(tc)
end
function c511015106.atkop(e,tp,eg,ev,ep,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end
