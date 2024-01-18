*-----------------------------------------------------------------------------
* <Rating>858</Rating>
*-----------------------------------------------------------------------------
!    PROGRAM FD.BAL
    SUBROUTINE FD.BAL(Y.DATA)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT

!DEBUG

    Y.ACC.LIST = ''
    Y.SEL.LIST = ''
    FN.ACCOUNT = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    FN.AZ.AC = 'FBNK.AZ.ACCOUNT'
    F.AZ.AC = ''
    Y.AZ.AC.ID = ''
    R.AZ.AC = ''
    AZ.AC.ERR = ''
    Y.AZ.LIQ.LIST = ''
    Y.DATA = ''

!    DEBUG
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.AZ.AC,F.AZ.AC)
    GOSUB GET.AZ.LIQ.LIST
!    CRT Y.AZ.LIQ.LIST

    CMD = 'SELECT ':FN.ACCOUNT:' WITH CATEGORY EQ 1052 AND CO.CODE EQ ':ID.COMPANY
    CALL EB.READLIST(CMD,Y.ACC.LIST,'',NO.OF.RECS,RET.CODE)
    IF Y.ACC.LIST THEN
        LOOP
            REMOVE Y.LIQ.AC.ID FROM Y.ACC.LIST SETTING POS
        WHILE Y.LIQ.AC.ID : POS
            Y.ACC.TITLE = ''
            Y.LIQ.BAL = 0
            Y.PRINCIPAL  = 0
            Y.PRINCIPAL.BASE  = 0
            Y.INT.RATE = ''
            Y.START.DATE = ''
            Y.MATURITY.DATE = ''
            Y.LEGACY.AC.ID = ''
            Y.LIQ.TITLE = ''

            CALL F.READ(FN.ACCOUNT,Y.LIQ.AC.ID,R.LIQ.AC,F.ACCOUNT,LIQ.AC.ERR)
            IF R.LIQ.AC THEN
                Y.LIQ.TITLE = R.LIQ.AC<AC.SHORT.TITLE>
                Y.LIQ.BAL = R.LIQ.AC<AC.WORKING.BALANCE>
            END
            FIND Y.LIQ.AC.ID IN Y.AZ.LIQ.LIST SETTING FLD.NO THEN
                Y.AZ.AC.ID = Y.AZ.LIQ.LIST<FLD.NO,1>
                Y.AZ.LIQ.LIST<FLD.NO>  = ''
                IF Y.AZ.AC.ID  THEN
                    CALL F.READ(FN.AZ.AC,Y.AZ.AC.ID,R.AZ.AC,F.AZ.AC,AZ.AC.ERR)
                    IF R.AZ.AC THEN
                        Y.PRINCIPAL  = R.AZ.AC<AZ.PRINCIPAL>
                        Y.INT.RATE = R.AZ.AC<AZ.INTEREST.RATE>
                        Y.START.DATE = R.AZ.AC<AZ.VALUE.DATE>
                        Y.MATURITY.DATE = R.AZ.AC<AZ.MATURITY.DATE>
                    END
                    CALL F.READ(FN.ACCOUNT,Y.AZ.AC.ID,R.BASE.AC,F.ACCOUNT,LIQ.AC.ERR)
                    IF R.BASE.AC THEN
                        Y.ACC.TITLE = R.BASE.AC<AC.SHORT.TITLE>
                        Y.LEGACY.AC.ID = R.BASE.AC<AC.ALT.ACCT.ID>
                        Y.PRINCIPAL.BASE = R.BASE.AC<AC.WORKING.BALANCE>
                    END

                END
            END
            ELSE
                Y.AZ.AC.ID = ''
                Y.ACC.TITLE = Y.LIQ.TITLE
            END
            Y.DATA<-1> = Y.AZ.AC.ID :'*':Y.LIQ.AC.ID:'*':Y.LEGACY.AC.ID:'*':Y.ACC.TITLE:'*':Y.INT.RATE:'*':Y.START.DATE:'*':Y.MATURITY.DATE:'*':Y.PRINCIPAL:'*':Y.PRINCIPAL.BASE:'*':Y.LIQ.BAL
        REPEAT
    END
!    CRT Y.AZ.LIQ.LIST
********THIS PORTION IS TO GET THOSE AZ FOR WHICH NO LIQUIDATION FOUND OR LIQUIDATION IS NOT IN 1052 CATEGORY*************************************************************
    IF Y.AZ.LIQ.LIST THEN
*Some AZ still remain to consider
        I = 0
        J = DCOUNT(Y.AZ.LIQ.LIST,FM)
        LOOP
            I = I + 1
        WHILE I LE J
            IF Y.AZ.LIQ.LIST<I> NE '' THEN
                Y.PRINCIPAL  = 0
                Y.INT.RATE = 0
                Y.START.DATE = ''
                Y.MATURITY.DATE = ''
                Y.ACC.TITLE = ''
                Y.LIQ.AC.ID = ''
                Y.LIQ.BAL = 0
                Y.LEGACY.AC.ID = ''
                Y.PRINCIPAL.BASE = ''
                Y.REMARKS = ''
                Y.AZ.ID = Y.AZ.LIQ.LIST<I,1>
                CALL F.READ(FN.AZ.AC,Y.AZ.ID,R.AZ.AC,F.AZ.AC,AZ.AC.ERR)
                IF R.AZ.AC THEN
                    Y.PRINCIPAL  = R.AZ.AC<AZ.PRINCIPAL>
                    Y.INT.RATE = R.AZ.AC<AZ.INTEREST.RATE>
                    Y.START.DATE = R.AZ.AC<AZ.VALUE.DATE>
                    Y.MATURITY.DATE = R.AZ.AC<AZ.MATURITY.DATE>
                    Y.LIQ.AC.ID = R.AZ.AC<AZ.NOMINATED.ACCOUNT>
                END
                CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.AZ.AC,F.ACCOUNT,LIQ.AC.ERR)
                IF R.AZ.AC THEN
                    Y.ACC.TITLE = R.AZ.AC<AC.SHORT.TITLE>
                    Y.LEGACY.AC.ID = R.AZ.AC<AC.ALT.ACCT.ID>
                    Y.PRINCIPAL.BASE = R.AZ.AC<AC.WORKING.BALANCE>

                END
                IF Y.LIQ.AC.ID EQ '' THEN
                    Y.REMARKS = 'No Liquidation account found'
                END
                ELSE
                    CALL F.READ(FN.ACCOUNT,Y.LIQ.AC.ID,R.LIQ.AC,F.ACCOUNT,LIQ.AC.ERR)
                    IF R.LIQ.AC THEN
                        Y.LIQ.BAL = R.LIQ.AC<AC.WORKING.BALANCE>
                    END
                    Y.REMARKS = 'Liquidation Account No:':Y.LIQ.AC.ID:' with balance ':Y.LIQ.BAL:' found is not in 1052 Category'
                    Y.LIQ.AC.ID = ''
                END
                Y.DATA<-1> = Y.AZ.ID :'*':Y.LIQ.AC.ID:'*':Y.LEGACY.AC.ID:'*':Y.ACC.TITLE:'*':Y.INT.RATE:'*':Y.START.DATE:'*':Y.MATURITY.DATE:'*':Y.PRINCIPAL:'*':Y.PRINCIPAL.BASE:'*':Y.LIQ.BAL:'*':Y.LIQ.BAL
            END

        REPEAT
    END
**************************************************************************
  !  CRT Y.DATA
*-----------------*
GET.AZ.LIQ.LIST:
*-----------------*
!  DEBUG
    Y.AZ.CAT = ''
    SEL.CMD = 'SELECT ':FN.AZ.AC:' WITH CO.CODE EQ ':ID.COMPANY
    CALL EB.READLIST(SEL.CMD,Y.SEL.LIST,'',NO.OF.REC,RET.CODE)
    IF Y.SEL.LIST THEN
        LOOP
            REMOVE Y.AZ.AC.ID FROM Y.SEL.LIST SETTING AC.POS
        WHILE Y.AZ.AC.ID:AC.POS
            CALL F.READ(FN.AZ.AC,Y.AZ.AC.ID,R.AZ.AC,F.AZ.AC,AZ.AC.ERR)
            IF R.AZ.AC THEN
                Y.AZ.CAT = R.AZ.AC<AZ.CATEGORY>
                IF Y.AZ.CAT EQ 6621 THEN
                    Y.LIQ.ID = R.AZ.AC<AZ.NOMINATED.ACCOUNT>
                    Y.AZ.LIQ.LIST<-1> = Y.AZ.AC.ID :VM: Y.LIQ.ID
                END
            END
        REPEAT
    END
    RETURN
