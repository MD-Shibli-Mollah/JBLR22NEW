
SUBROUTINE GB.JB.CR.TTTI.CKID

*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: EB.JBL.TT.TELLER.ID,INPUT , EB.JBL.TT.TELLER.ID,VAULT

* Attach As: Check Record ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTTI.CKID
* 23/09/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* IN.WORDS of R09 will be LT.AMT.WORD for LRT of TELLER
*
*--------------------------------------------------------------------------------
   
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.JBL.TT.TELLER.ID
    
    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING ST.CompanyCreation
    $USING EB.Security
*
    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.APPLICATION = EB.SystemTables.getApplication()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.OPERATOR = EB.SystemTables.getOperator()

    IF Y.VFUNCTION EQ 'D' THEN
        RETURN
    END

    FN.TT = 'F.TELLER'
    F.TT = ''
    FN.TI = 'F.TELLER.ID'
    F.TI = ''
    FN.TU = 'F.TELLER.USER'
    F.TU = ''
    FN.TTI = 'F.EB.JBL.TT.TELLER.ID'
    F.TTI = ''
    FN.TTI.NAU = 'F.EB.JBL.TT.TELLER.ID$NAU'
    F.TTI.NAU = ''
    FN.CO = 'F.COMPANY'
    F.CO = ''
    FN.U = 'F.USER'
    F.U = ''
    FN.RL = 'F.RECORD.LOCK'
    F.RL = ''
    
    EB.DataAccess.Opf(FN.U,F.U)
    EB.DataAccess.Opf(FN.RL,F.RL)
    EB.DataAccess.Opf(FN.CO,F.CO)
    EB.DataAccess.Opf(FN.TT,F.TT)
    EB.DataAccess.Opf(FN.TI,F.TI)
    EB.DataAccess.Opf(FN.TU,F.TU)
    EB.DataAccess.Opf(FN.TTI,F.TTI)
    EB.DataAccess.Opf(FN.TTI.NAU,F.TTI.NAU)

    IF Y.APPLICATION EQ 'TELLER' THEN
        Y.TELLER.ID.1 = EB.SystemTables.getRNew(TT.Contract.Teller.TeTellerIdOne)
        Y.TELLER.ID.2 = EB.SystemTables.getRNew(TT.Contract.Teller.TeTellerIdTwo)
*        CALL GET.LOC.REF("TELLER","LT.AMT.WORD",Y.POS)
        EB.LocalReferences.GetLocRef("TELLER","LT.AMT.WORD",Y.POS)
*        Y.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        Y.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
* CALL AMTW(Y.AMT,Y.WORD)
        CALL CM.CALHUND(Y.AMT,Y.WORD)
* R.NEW(TT.TE.LOCAL.REF)<1,Y.POS> = Y.WORD
        Y.TEMP = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        Y.TEMP<1,Y.POS> =  Y.WORD
        EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, Y.TEMP)
    END

    Y.VER.ID = Y.APPLICATION : Y.PGM.VERSION
    
    IF Y.VER.ID EQ 'TELLER,TILL.TO.VAULT' THEN
        EB.DataAccess.FRead(FN.TU, Y.OPERATOR, R.TU, F.TU, ERR.TU)
        IF R.TU NE '' THEN
            EB.DataAccess.FRead(FN.TI,R.TU<1>,R.TI,F.TI,ERR.TI)
            Y.TID.STATUS = R.TI<TT.Contract.TellerId.TidStatus>

            IF Y.TID.STATUS EQ 'OPEN' THEN
* R.NEW(TT.TE.TELLER.ID.2) = R.TU<1>
                Y.R.TU.1 = R.TU<1>
                EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdTwo, Y.R.TU.1)
            END
            ELSE
*                    AF = TT.TE.TELLER.ID.2
                EB.SystemTables.setAf(TT.Contract.Teller.TeTellerIdTwo)
*                    ETEXT = 'Teller ID is not Open.'
                EB.SystemTables.setEtext('Teller ID is not Open.')
*                    CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END

    
    IF Y.VER.ID EQ 'TELLER,VAULT.TO.TILL' THEN
        EB.DataAccess.FRead(FN.TU, Y.OPERATOR, R.TU, F.TU, ERR.TU)
        IF R.TU NE '' THEN
            EB.DataAccess.FRead(FN.TI,R.TU<1>,R.TI,F.TI,ERR.TI)
            Y.TID.STATUS = R.TI<TT.Contract.TellerId.TidStatus>
                
            IF Y.TID.STATUS EQ 'OPEN' THEN
* R.NEW(TT.TE.TELLER.ID.1) = R.TU<1>
                Y.R.TU.1 = R.TU<1>
                EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne, Y.R.TU.1)
            END
            ELSE
*                    AF = TT.TE.TELLER.ID.1
                EB.SystemTables.setAf(TT.Contract.Teller.TeTellerIdOne)
*                    ETEXT = 'Teller ID is not Open.'
                EB.SystemTables.setEtext('Teller ID is not Open.')
*                    CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END
        
    IF Y.VER.ID EQ 'TELLER,LCY.TILLTFR' OR Y.VER.ID EQ 'TELLER,FCY.TILLTFR' THEN
        EB.DataAccess.FRead(FN.TU, Y.OPERATOR, R.TU, F.TU, ERR.TU)
        Y.R.TU.1 = R.TU<1>
                
        IF (Y.R.TU.1 EQ Y.TELLER.ID.1) OR (Y.R.TU.1 EQ Y.TELLER.ID.2) THEN
            EB.DataAccess.FRead(FN.TI, Y.TELLER.ID.1, R.TI, F.TI, ERR.TI)
            Y.TID.STATUS = R.TI<TT.Contract.TellerId.TidStatus>
                    
            IF Y.TID.STATUS NE 'OPEN' THEN
*                        AF = TT.TE.TELLER.ID.1
                EB.SystemTables.setAf(TT.Contract.Teller.TeTellerIdOne)
*                        ETEXT = 'Teller ID: ':R.NEW(TT.TE.TELLER.ID.1):' is not Open.'
                EB.SystemTables.setEtext('Teller ID: ':Y.TELLER.ID.1:' is not Open.')
*                        CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            EB.DataAccess.FRead(FN.TI, Y.TELLER.ID.2, R.TI, F.TI, ERR.TI)
            Y.TID.STATUS = R.TI<TT.Contract.TellerId.TidStatus>
                    
            IF Y.TID.STATUS NE 'OPEN' THEN
*                        AF = TT.TE.TELLER.ID.2
                EB.SystemTables.setAf(TT.Contract.Teller.TeTellerIdTwo)
*                        ETEXT = 'Teller ID: ':R.NEW(TT.TE.TELLER.ID.2):' is not Open.'
                EB.SystemTables.setEtext('Teller ID: ':Y.TELLER.ID.2:' is not Open.')
*                        CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
        ELSE
            EB.SystemTables.setAf(0)
            Y.R.TU.1 = R.TU<1>
            EB.DataAccess.FRead(FN.TI, Y.R.TU.1, R.TI, F.TI, ERR.TI)
            IF R.TI EQ '' THEN
*                    ETEXT = 'Inputter must have Teller ID.' ELSE ETEXT = R.TU<1>:' must be placed in Teller IDs.'
                EB.SystemTables.setEtext('Inputter must have Teller ID.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            ELSE
*ETEXT = R.TU<1>:' must be placed in Teller IDs.'
                EB.SystemTables.setEtext(Y.R.TU.1:' must be placed in Teller IDs.')
*                    CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END
    
    IF (Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,INPUT') OR (Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,VAULT') THEN
        Y.TI = Y.ID.NEW
        IF LEN(Y.ID.NEW) EQ 9 THEN
            Y.TI = FIELD(Y.ID.NEW,'.',1)
            Y.BRC = FIELD(Y.ID.NEW,'.',2)
        END
        ELSE
            Y.BRC = Y.ID.COMPANY[6,4]
            GOSUB DEL.RL
        END
        IF (LEN(Y.TI) NE 4) OR (LEN(Y.BRC) NE 4) OR (NUM(Y.TI) NE 1) OR (NUM(Y.BRC) NE 1) OR (LEN(Y.TI) LE 3) OR (Y.BRC NE Y.ID.COMPANY[6,4]) OR (Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,INPUT' AND Y.TI EQ '9999') OR (Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,VAULT' AND Y.TI NE '9999') THEN
*                E = 'Invalid ID Entered. Please enter Teller ID OR Use TellerID.BracnhCode.'
            EB.SystemTables.setE('Invalid ID Entered. Please enter Teller ID OR Use TellerID.BranchCode.')
*                CALL STORE.END.ERROR
            EB.ErrorProcessing.StoreEndError()
            GOSUB DEL.RL
            RETURN
        END

        EB.DataAccess.FRead(FN.CO, Y.ID.COMPANY, R.CO, F.CO, ERR.CO)
        Y.COMPANY.NAME = R.CO<ST.CompanyCreation.Company.EbComCompanyName>
*            R.NEW(TTTI.BR.INFO) = ID.COMPANY[6,4]:' ':R.CO<EB.COM.COMPANY.NAME>
        Y.BR.INFO = Y.ID.COMPANY[6,4]:' ':Y.COMPANY.NAME
*            R.NEW(TTTI.TELLER.ID) = Y.TI
        EB.SystemTables.setRNew(TT.Contract.Teller.TeTellerIdOne, Y.TI)

        IF Y.TI EQ '9999' THEN
*                R.NEW(TTTI.CATEGORY) = 10011
            EB.SystemTables.setRNew(EB.JBL91.CATEGORY, 10011)
*                R.NEW(TTTI.USER.ID) = 'VAULT'
            EB.SystemTables.setRNew(EB.JBL91.USER.ID, 'VAULT')
*                R.NEW(TTTI.USER.INFO) = 'VAULT'
            EB.SystemTables.setRNew(EB.JBL91.USER.INFO, 'VAULT')
*                T(TTTI.COUNTER.LIMIT)<3> = "NOINPUT"
            EB.SystemTables.setT(EB.JBL91.COUNTER.LIMIT, "NOINPUT")
*                T(TTTI.DR.CR)<3> = "NOINPUT"
            EB.SystemTables.setT(EB.JBL91.DR.CR, "NOINPUT")
*                T(TTTI.LIMIT)<3> = "NOINPUT"
            EB.SystemTables.setT(EB.JBL91.LIMIT, "NOINPUT")
        END
        ELSE
* T(TTTI.SAFE.LIMIT)<3> = "NOINPUT"
            EB.SystemTables.setT(EB.JBL91.SAFE.LIMIT, "NOINPUT")
            EB.DataAccess.FRead(FN.TI, Y.TI, R.TI, F.TI, ERR.TI)
            IF R.TI EQ '' THEN
*                    E = 'Teller ID not found.'
                EB.SystemTables.setE('Teller ID not found.')
*                    CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                GOSUB DEL.RL
                RETURN
            END
                
            Y.TID.CO.CODE = R.TI<TT.Contract.TellerId.TidCoCode>
            IF Y.TID.CO.CODE NE Y.ID.COMPANY THEN
*                    E = 'Teller ID is not available in this branch.'
                EB.SystemTables.setE('Teller ID is not available in this branch.')
*                    CALL STORE.END.ERROR
                EB.ErrorProcessing.StoreEndError()
                GOSUB DEL.RL
                RETURN
            END
            Y.TID.STATUS = R.TI<TT.Contract.TellerId.TidStatus>
            IF Y.TID.STATUS NE 'OPEN' THEN
                EB.SystemTables.setE('Teller ID is not Open.')
                EB.ErrorProcessing.StoreEndError()
                GOSUB DEL.RL
                RETURN
            END
            Y.TID.USER = R.TI<TT.Contract.TellerId.TidUser>
*                R.NEW(TTTI.USER.ID) = R.TI<TT.TID.USER>
            EB.SystemTables.setRNew(EB.JBL91.USER.ID, Y.TID.USER)

            Y.TID.CATEGORY = R.TI<TT.Contract.TellerId.TidCategory>
*                R.NEW(TTTI.CATEGORY) = R.TI<TT.TID.CATEGORY>
            EB.SystemTables.setRNew(EB.JBL91.CATEGORY, Y.TID.CATEGORY)

            EB.DataAccess.FRead(FN.U, Y.TID.USER, R.U, F.U, ERR.U)
            Y.EB.USER.NAME = R.U<EB.Security.User.UseUserName>
* R.NEW(TTTI.USER.INFO) = R.U<EB.USE.USER.NAME>
            EB.SystemTables.setRNew(EB.JBL91.USER.INFO, Y.EB.USER.NAME)
        END
        
* ID.NEW = Y.TI:'.':ID.COMPANY[6,4]
        Y.ID.NEW = Y.TI:'.':Y.ID.COMPANY[6,4]
* EB.SystemTables.setIdNew(Y.ID.NEW)
        EB.DataAccess.FRead(FN.TTI.NAU, Y.ID.NEW, R.CK, F.TTI.NAU, ERR.CK.NAU)
        IF R.CK NE '' THEN
            GOSUB OLD_ENTRY
            RETURN
        END
        EB.DataAccess.FRead(FN.TTI, Y.ID.NEW, R.CK, F.TTI, ERR.CK)
        IF R.CK NE '' THEN
            GOSUB OLD_ENTRY
            RETURN
        END
    END
RETURN

OLD_ENTRY:
    !DEBUG
*        R.NEW(TTTI.USER.ID) = R.CK<TTTI.USER.ID>
    Y.USER.ID = R.CK<EB.JBL91.USER.ID>
    EB.SystemTables.setRNew(EB.JBL91.USER.ID, Y.USER.ID)
*        R.NEW(TTTI.USER.INFO) = R.CK<TTTI.USER.INFO>
    Y.USER.INFO = R.CK<EB.JBL91.USER.INFO>
    EB.SystemTables.setRNew(EB.JBL91.USER.INFO, Y.USER.INFO)
*        R.NEW(TTTI.CATEGORY) = R.CK<TTTI.CATEGORY>
    Y.CATEGORY = R.CK<EB.JBL91.CATEGORY>
    EB.SystemTables.setRNew(EB.JBL91.CATEGORY, Y.CATEGORY)
*        R.NEW(TTTI.CCY) = R.CK<TTTI.CCY>
    Y.CCY = R.CK<EB.JBL91.CCY>
    EB.SystemTables.setRNew(EB.JBL91.CCY, Y.CCY)
*        R.NEW(TTTI.DR.CR) = R.CK<TTTI.DR.CR>
    Y.DR.CR = R.CK<EB.JBL91.DR.CR>
    EB.SystemTables.setRNew(EB.JBL91.DR.CR, Y.DR.CR)
*        R.NEW(TTTI.LIMIT) = R.CK<TTTI.LIMIT>
    Y.LIMIT = R.CK<EB.JBL91.LIMIT>
    EB.SystemTables.setRNew(EB.JBL91.LIMIT, Y.LIMIT)
*        R.NEW(TTTI.SAFE.LIMIT) = R.CK<TTTI.SAFE.LIMIT>
    Y.SAFE.LIMIT = R.CK<EB.JBL91.SAFE.LIMIT>
    EB.SystemTables.setRNew(EB.JBL91.SAFE.LIMIT, Y.SAFE.LIMIT)
*        R.NEW(TTTI.COUNTER.LIMIT) = R.CK<TTTI.COUNTER.LIMIT>
    Y.COUNTER.LIMIT = R.CK<EB.JBL91.COUNTER.LIMIT>
    EB.SystemTables.setRNew(EB.JBL91.COUNTER.LIMIT, Y.COUNTER.LIMIT)
*        R.NEW(TTTI.IN.WORD) = R.CK<TTTI.IN.WORD>
    Y.IN.WORD = R.CK<EB.JBL91.IN.WORD>
    EB.SystemTables.setRNew(EB.JBL91.IN.WORD, Y.IN.WORD)
RETURN

DEL.RL:
    RL.ID = 'FBNK.EB.JBL.TT.TELLER.ID$NAU':'.':Y.ID.NEW
    EB.DataAccess.FRead(FN.RL,RL.ID,R.RL,F.RL,ERR.RL)
    DELETE F.RL, RL.ID
RETURN
END
