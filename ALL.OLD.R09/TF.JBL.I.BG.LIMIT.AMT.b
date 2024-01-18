SUBROUTINE TF.JBL.I.BG.LIMIT.AMT
*-----------------------------------------------------------------------------
*Subroutine Description: Limit check for BG
*Subroutine Type:
*Attached To    : MD.DEAL (MD.DEAL,JBL.APG , MD.DEAL,JBL.BBOND , MD.DEAL,JBL.CGE , MD.DEAL,JBL.GTISS ,  MD.DEAL,JBL.OPNGTE  , MD.DEAL,JBL.PBOND
* MD.DEAL,JBL.PG ,  MD.DEAL,JBL.SHIPG , MD.DEAL,JBL.SHIPG.BTB   , MD.DEAL,JBL.SHIPG.IMP )
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/09/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING MD.Contract
    $USING LI.Contract
    $USING LI.Config
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BG = 'F.MD.DEAL'
    F.BG = ''

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.BG,F.BG)
    EB.DataAccess.Opf(FN.LIMIT,F.LIMIT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LIMIT.REFEREMNCE = EB.SystemTables.getRNew(MD.Contract.Deal.DeaLimitReference)
    Y.ISSUE.AMOUNT = EB.SystemTables.getRNew(MD.Contract.Deal.DeaPrincipalAmount)
    Y.CUSTOMER = EB.SystemTables.getRNew(MD.Contract.Deal.DeaCustomer)
    Y.LIMIT.P=Y.LIMIT.REFEREMNCE[1,2]
    Y.LIMIT.S=Y.LIMIT.REFEREMNCE[6,2]
    Y.P.LIMIT.ID = Y.CUSTOMER:'.000':Y.LIMIT.P:'00.':Y.LIMIT.S
    Y.C.LIMIT.ID = Y.CUSTOMER:'.000':Y.LIMIT.REFEREMNCE
    
    EB.DataAccess.FRead(FN.LIMIT,Y.P.LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
    IF R.LIMIT THEN
        Y.AVAIL.AMOUNT1 = R.LIMIT<LI.Config.Limit.AvailAmt>
    END
    IF Y.AVAIL.AMOUNT1 EQ '' THEN
        Y.AVAIL.AMOUNT1 = 0
    END
    
    EB.DataAccess.FRead(FN.LIMIT,Y.C.LIMIT.ID,R.LIMIT2,F.LIMIT,LIMIT.ERR)
    IF R.LIMIT2 THEN
        Y.AVAIL.AMOUNT2 = R.LIMIT2<LI.Config.Limit.AvailAmt>
    END
    IF Y.AVAIL.AMOUNT2 EQ '' THEN
        Y.AVAIL.AMOUNT2 = 0
    END
    IF Y.AVAIL.AMOUNT1 < Y.AVAIL.AMOUNT2 THEN
        Y.AVAIL.AMOUNT = Y.AVAIL.AMOUNT1 + Y.ISSUE.AMOUNT
    END
    ELSE
        Y.AVAIL.AMOUNT = Y.AVAIL.AMOUNT2 + Y.ISSUE.AMOUNT
    END

    IF Y.ISSUE.AMOUNT GT Y.AVAIL.AMOUNT THEN
        EB.SystemTables.setAf(MD.Contract.Deal.DeaLimitReference)
        EB.SystemTables.setEtext("Excess Over Limit is not Allowed")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
*** </region>
END
