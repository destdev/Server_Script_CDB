--魔導の封印櫃
function c511001194.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001194.target)
	e1:SetOperation(c511001194.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c511001194.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c511001194.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	e:SetLabelObject(nil)
end
function c511001194.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,cg)
		local g=Duel.SelectMatchingCard(tp,c511001194.filter,tp,0,LOCATION_DECK,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
			Duel.ShuffleDeck(1-tp)
			e:SetLabelObject(g:GetFirst())
		end
	end
end
function c511001194.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c511001194.tohand)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(e:GetLabelObject():GetLabelObject())
	Duel.RegisterEffect(e1,tp)
end
function c511001194.tohand(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	Duel.Hint(HINT_CARD,0,511001194)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(tp,tc)
	Duel.ShuffleHand(1-tp)
end
