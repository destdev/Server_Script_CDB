--アスポート
--Asport
--Scripted by Eerie Code
function c101003064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101003064.target)
	e1:SetOperation(c101003064.activate)
	c:RegisterEffect(e1)
end
function c101003064.filter(c)
	return c:GetSequence()<5
end
function c101003064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101003064.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101003064.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101003064,0))
	Duel.SelectTarget(tp,c101003064.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101003064.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,nil)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
