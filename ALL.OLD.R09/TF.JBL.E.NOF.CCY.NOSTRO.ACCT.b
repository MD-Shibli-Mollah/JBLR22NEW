SUBROUTINE TF.JBL.E.NOF.CCY.NOSTRO.ACCT(Y.DATA)
*-----------------------------------------------------------------------------
* Description : this routine retrieve currency wise nostro account from CCY.NOSTRO.ACCT application.
* Create By: Mahmudur Rahman Udoy
* Attach Enquriy: JBL.ENQ.CCY.NOSTRO.ACCT
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Reports
    $USING ST.Config
    $USING AC.AccountOpening
    $USING ST.CompanyCreation
 
*-----------------------------------------------------------------------------
    GOSUB INIT ; *For Initialzation variable
    GOSUB OPENFILES
    GOSUB PROCESS ; *For process data
*-----------------------------------------------------------------------------


*-----------------------------------------------------------------------------

*** <region name= INIT>
INIT:
    Y.NOS.CCY = ''
    FN.CCY.NOSTRO.ACCT = 'F.CCY.NOSTRO.ACCT'
    F.CCY.NOSTRO.ACCT = ''
    LOCATE 'CURRENCY' IN EB.Reports.getEnqSelection()<2,1> SETTING CCY.POS THEN
        Y.NOS.CCY = EB.Reports.getEnqSelection()<4,CCY.POS>
    END
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.CCY.NOSTRO.ACCT, F.CCY.NOSTRO.ACCT)
RETURN
 
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
    IF Y.NOS.CCY NE '' THEN
        EB.DataAccess.FRead(FN.CCY.NOSTRO.ACCT, Y.NOS.CCY, REC.ACCT, F.CCY.NOSTRO.ACCT, ERR.ACCT)
        CONVERT VM TO FM IN REC.ACCT
        Y.DATE.COUNT = DCOUNT(REC.ACCT,@FM)
        FOR U = 1 TO Y.DATE.COUNT
            Y.DATA<-1> = REC.ACCT<U>
        NEXT U
    END
    ELSE
        SEL.CMD = "SELECT ":FN.CCY.NOSTRO.ACCT
        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,"",NO.OF.RECORD,RET.CODE)
        LOOP
            REMOVE Y.CCY.NOSTRO.ID FROM SEL.LIST SETTING Y.POS
        WHILE Y.CCY.NOSTRO.ID:Y.POS
            EB.DataAccess.FRead(FN.CCY.NOSTRO.ACCT, Y.CCY.NOSTRO.ID, REC.ACCT, F.CCY.NOSTRO.ACCT, ERR.ACCT)
            CONVERT VM TO FM IN REC.ACCT
            Y.DATE.COUNT = DCOUNT(REC.ACCT,@FM)
            FOR U = 1 TO Y.DATE.COUNT
                Y.DATA<-1> = REC.ACCT<U>
            NEXT U
        REPEAT
    END
RETURN

END

