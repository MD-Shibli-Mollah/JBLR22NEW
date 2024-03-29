    SUBROUTINE ANYDAY.DDPAY.N.ADV.Y(Y.RETURN)
!PROGRAM ANYDAY.DDPAY.N.ADV.Y
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT I_F.ABL.H.DD.DETAILS

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

INIT:
    FN.DD='F.ABL.H.DD.DETAILS'
    F.DD=''

    Y.RESULT = ''
    Y.RETURN = ''

    LOCATE "ISSUE.BR" IN ENQ.SELECTION<2,1> SETTING ISSUE.BR.POS THEN
        Y.ISS.BR = ENQ.SELECTION<4,ISSUE.BR.POS>
    END
    RETURN

OPENFILES:
    CALL OPF(FN.DD,F.DD)
    RETURN

PROCESS:
!SEL.CMD.DD="SELECT ":FN.DD
!------Modifield by Aminul----------
    SEL.CMD.DD='SELECT ':FN.DD:" WITH @ID LIKE ...":ID.COMPANY[6,4]:'...'
!------Modification end----------
    CALL EB.READLIST(SEL.CMD.DD,SEL.LIST.DD,'',NO.OF.REC.DD,ERR.DD)
    LOOP
        REMOVE Y.DD.ID FROM SEL.LIST.DD SETTING POS.DD
    WHILE Y.DD.ID:POS.DD
        CALL F.READ(FN.DD,Y.DD.ID,REC.DD,F.DD,E.DD)
        Y.ADVICE = REC.DD<DDT.ADVICE>
        Y.INS.PAID = REC.DD<DDT.INS.PAID>
        Y.CO.CODE = REC.DD<DDT.CO.CODE>
        Y.ISSUE.BR = FIELD(Y.DD.ID,".",2,1)

        BEGIN CASE
        CASE Y.ADVICE EQ 'Y' AND Y.INS.PAID EQ 'N' AND Y.CO.CODE EQ ID.COMPANY AND (Y.ISS.BR EQ '' OR Y.ISS.BR EQ 'ALL')
            Y.INS.PRINTED.NO = REC.DD<DDT.INS.PRINTED.NO>
            Y.SCROLL = FIELD(Y.DD.ID,".",5,1)
            Y.DATE.OF.ISSUE = REC.DD<DDT.DATE.OF.ISSUE>
            Y.BENIFICIARY = REC.DD<DDT.BENIFICIARY>
            Y.ADV.DATE.OF.PAY = REC.DD<DDT.ADV.DATE.OF.PAY>
            Y.AMOUNT = REC.DD<DDT.AMOUNT>
            Y.PAY.ADVICE.NO = REC.DD<DDT.PAY.ADVICE.NO>
            Y.RESULT<-1>=Y.ISSUE.BR:"*":Y.INS.PRINTED.NO:"*":Y.SCROLL:"*":Y.DATE.OF.ISSUE:"*":Y.BENIFICIARY:"*":Y.ADV.DATE.OF.PAY:"*":Y.AMOUNT:"*":Y.PAY.ADVICE.NO

        CASE Y.ADVICE EQ 'Y' AND Y.INS.PAID EQ 'N' AND Y.CO.CODE EQ ID.COMPANY AND Y.ISS.BR NE '' AND Y.ISS.BR EQ Y.ISSUE.BR
            Y.INS.PRINTED.NO = REC.DD<DDT.INS.PRINTED.NO>
            Y.SCROLL = FIELD(Y.DD.ID,".",5,1)
            Y.DATE.OF.ISSUE = REC.DD<DDT.DATE.OF.ISSUE>
            Y.BENIFICIARY = REC.DD<DDT.BENIFICIARY>
            Y.ADV.DATE.OF.PAY = REC.DD<DDT.ADV.DATE.OF.PAY>
            Y.AMOUNT = REC.DD<DDT.AMOUNT>
            Y.PAY.ADVICE.NO = REC.DD<DDT.PAY.ADVICE.NO>
            Y.RESULT<-1>=Y.ISSUE.BR:"*":Y.INS.PRINTED.NO:"*":Y.SCROLL:"*":Y.DATE.OF.ISSUE:"*":Y.BENIFICIARY:"*":Y.ADV.DATE.OF.PAY:"*":Y.AMOUNT:"*":Y.PAY.ADVICE.NO
        CASE 1
        END CASE

    REPEAT
    Y.RETURN=SORT(Y.RESULT)
    RETURN
END
