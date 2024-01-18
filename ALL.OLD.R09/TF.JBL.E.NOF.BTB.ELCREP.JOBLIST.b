* @ValidationCode : MjoxODc0NzcyNjE6Q3AxMjUyOjE1NjIwMTIyOTk5NzY6REVMTDotMTotMTowOjA6ZmFsc2U6Ti9BOlIxN19BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jul 2019 02:18:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.E.NOF.BTB.ELCREP.JOBLIST(Y.RETURN)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History : Limon
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
*-----------------------------------------------------------------------------
    $USING EB.DataAccess

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    !FN.SCT = 'F.BD.SCT.CAPTURE';            F.SCT = ''
    FN.BTB.JR = 'F.BD.BTB.JOB.REGISTER';    F.BTB.JR = ''

    !LOCATE 'SCT.ID' IN D.FIELDS<1> SETTING POS1 ELSE POS1 = ''
    !Y.TF.SCONT.ID.LIST = D.RANGE.AND.VALUE<POS1,1>
    LOCATE 'CUSTOMER.ID' IN D.FIELDS<1> SETTING POS1 ELSE POS1 = ''
    Y.CUSTOMER.ID = D.RANGE.AND.VALUE<POS1,1>

RETURN

**********
OPENFILES:
**********
    !EB.DataAccess.Opf(FN.SCT,F.SCT)
    EB.DataAccess.Opf(FN.BTB.JR,F.BTB.JR)
RETURN

********
PROCESS:
********
    !Y.SCT.ID = Y.TF.SCONT.ID.LIST<1>
    !Y.SCT.CUSTOMER = Y.SCT.ID[4,6]
    IF Y.CUSTOMER.ID NE '' THEN
        SEL.CMD = "SELECT ":FN.BTB.JR:" WITH @ID LIKE '...":Y.CUSTOMER.ID:"...'"
    END ELSE
        SEL.CMD = "SELECT ":FN.BTB.JR
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)
    LOOP
        REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
    WHILE Y.REC.ID:Y.POS
        EB.DataAccess.FRead(FN.BTB.JR,Y.REC.ID,R.JR.REC,F.BTB.JR,JR.ERR)
        IF R.JR.REC THEN
            Y.JOB.CUS.ID = R.JR.REC<BTB.JOB.CUSTOMER.NO>
            Y.JOB.CURR = R.JR.REC<BTB.JOB.JOB.CURRENCY>
        END
        Y.RETURN<-1> = Y.REC.ID:"*":Y.JOB.CUS.ID:"*":Y.JOB.CURR
    REPEAT

RETURN
END
