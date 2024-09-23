
SUBROUTINE GB.JBL.BA.TTTI.CK
    
*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: VERSION - EB.JBL.TT.TELLER.ID,INPUT , EB.JBL.TT.TELLER.ID,VAULT
* Attach As: BEFORE AUTH ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTTI.CK
* 22/09/2024 -                          NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
*
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $INSERT I_F.EB.JBL.TT.TELLER.ID
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING ST.CompanyCreation
    $USING TT.Config
    $USING EB.ErrorProcessing

    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.APPLICATION = EB.SystemTables.getApplication()
    Y.PGM.VERSION = EB.SystemTables.getPgmVersion()
    Y.OPERATOR = EB.SystemTables.getOperator()

    FN.TT = 'F.TELLER'
    F.TT = ''
    FN.TI = 'F.TELLER.ID'
    F.TI = ''
    FN.TU = 'F.TELLER.USER'
    F.TU = ''
    FN.TTI = 'F.TT.TELLER.ID'
    F.TTI = ''
    FN.U = 'F.EB.USER.MGT'
    F.U = ''

    EB.DataAccess.Opf(FN.U,F.U)
    EB.DataAccess.Opf(FN.TTI,F.TTI)
    EB.DataAccess.Opf(FN.TT,F.TT)
    EB.DataAccess.Opf(FN.TI,F.TI)
    EB.DataAccess.Opf(FN.TU,F.TU)

    Y.VER.ID = Y.APPLICATION : Y.PGM.VERSION
    
    IF Y.VER.ID EQ 'TELLER,LCY.TILLTFR' OR Y.VER.ID EQ 'TELLER,FCY.TILLTFR' THEN
        EB.DataAccess.FRead(FN.TU, Y.OPERATOR, R.TU, F.TU, ERR.TU)
        Y.R.TU.1 = R.TU<1>
        Y.TELLER.ID.1 = EB.SystemTables.getRNew(TT.Contract.Teller.TeTellerIdOne)
        Y.TELLER.ID.2 = EB.SystemTables.getRNew(TT.Contract.Teller.TeTellerIdTwo)
        
        IF Y.R.TU.1 EQ Y.TELLER.ID.1 OR Y.R.TU.1 EQ Y.TELLER.ID.2 THEN
        END
    
        ELSE
* AF = 0
            EB.SystemTables.setAf(0)
            EB.DataAccess.FRead(FN.TI,R.TU<1>,R.TI,F.TI,ERR.TI)
            IF R.TI EQ '' THEN
                EB.SystemTables.setEtext('Authoriser must have Teller ID.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
            
            ELSE
                Y.R.TU.1 = R.TU<1>
                EB.SystemTables.setEtext(Y.R.TU.1:' must be placed in Teller IDs.')
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END
    
*--------------- Inputter or Authoriser Role need Further CLARIFICATION -------------------------*
*    IF Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,INPUT' OR Y.VER.ID EQ 'EB.JBL.TT.TELLER.ID,VAULT' THEN
*        Y.AUTH = Y.OPERATOR
*
*        SEL.CMD = 'SELECT ':FN.U:' WITH USER.ID EQ ':Y.AUTH
*
*        EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, F.U, NO.OF.REC, RET.CODE)
*        EB.DataAccess.FRead(FN.U, SEL.LIST<1>, R.U, F.U, RET.U)
** Y.AUTH.ROLE = R.U<EB.USE61.EMP.ROLE>
*
*        IF Y.AUTH.ROLE NE 'MANAGER' THEN
*            Y.TTTI.INPUTTER = EB.SystemTables.getRNew(EB.JBL91.INPUTTER)
*            Y.INPR = FIELD(Y.TTTI.INPUTTER,'_',2)
*
*            SEL.CMD = 'SELECT ':FN.U:' WITH USER.ID EQ ':Y.INPR
*
*            EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, F.U, NO.OF.REC, RET.CODE)
*            EB.DataAccess.FRead(FN.U, SEL.LIST<1>, R.U, F.U, RET.U)
**  Y.INPR.ROLE = R.U<EB.USE61.EMP.ROLE>
*            IF Y.INPR.ROLE EQ 'MANAGER' THEN Y.MROL = 1
*        END
*        ELSE
*            Y.MROL = 1
*        END
*    END
*
*    IF Y.MROL NE 1 THEN
** AF = 0
*        EB.SystemTables.setAf(0)
*        EB.SystemTables.setEtext('Inputter or Authoriser Role must be Manager.'
*        EB.ErrorProcessing.StoreEndError()
*        RETURN
*    END
*--------------- Inputter or Authoriser Role need Further CLARIFICATION  - END -------------------------*
RETURN
END


