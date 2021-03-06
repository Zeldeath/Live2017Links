--クリアウィング・ファスト・ドラゴン
function c90036274.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTunerEx(Card.IsAttribute,ATTRIBUTE_WIND),1,99)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90036274,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,90036274)
	e1:SetCost(c90036274.spcost)
	e1:SetTarget(c90036274.sptg)
	e1:SetOperation(c90036274.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90036274,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCountLimit(1,90036275)
	e2:SetCondition(c90036274.discon)
	e2:SetTarget(c90036274.distg)
	e2:SetOperation(c90036274.disop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90036274,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c90036274.pencon)
	e3:SetTarget(c90036274.pentg)
	e3:SetOperation(c90036274.penop)
	c:RegisterEffect(e3)
end
function c90036274.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2016) and c:IsType(TYPE_TUNER) and c:IsAbleToGraveAsCost()
end
function c90036274.cfilter2(c)
	return c:IsFaceup() and --c:IsNotTuner() 
		(not c:IsType(TYPE_TUNER) or c:IsHasEffect(EFFECT_NONTUNER)) and c:IsAbleToGraveAsCost()
end
function c90036274.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c90036274.chk,1,nil,sg) and sg:CheckWithSumEqual(Card.GetLevel,7,2,2)
end
function c90036274.chk(c,sg)
	return c90036274.cfilter1(c) and sg:IsExists(c90036274.cfilter2,1,c)
end
function c90036274.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c90036274.cfilter1,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c90036274.cfilter2,tp,LOCATION_MZONE,0,nil)
	local g=g1:Clone()
	g:Merge(g2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g1:GetCount()>0 and g2:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,2,2,c90036274.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c90036274.rescon,1,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c90036274.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c90036274.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c90036274.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c90036274.disfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not (c:GetAttack()==0 and c:IsDisabled())
end
function c90036274.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c90036274.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c90036274.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90036274.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c90036274.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
	end
end
function c90036274.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_EFFECT+REASON_BATTLE~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c90036274.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c90036274.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
