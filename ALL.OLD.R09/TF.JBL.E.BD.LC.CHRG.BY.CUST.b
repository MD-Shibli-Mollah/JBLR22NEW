SUBROUTINE TF.JBL.E.BD.LC.CHRG.BY.CUST

    !PROGRAM TF.JBL.E.BD.LC.CHRG.BY.CUST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History : LIMON
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    !$INSERT I_AA.LOCAL.COMMON
    $USING LC.Foundation
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Reports
    $USING ST.CompanyCreation
    $USING ST.Customer
    $USING EB.Updates
    
    

    !ST.CompanyCreation.LoadCompany('BNK')
    FN.LC.ACCOUNT.BALANCES = "F.LC.ACCOUNT.BALANCES"
    FV.LC.ACCOUNT.BALANCES = " "

    EB.DataAccess.Opf(FN.LC.ACCOUNT.BALANCES,FV.LC.ACCOUNT.BALANCES)
    !DEBUG
    Y.LC.NO = O.DATA
    ! Y.LC.NO = "TF2021911874"

    EB.DataAccess.FRead(FN.LC.ACCOUNT.BALANCES,Y.LC.NO,R.LC.REC,FV.LC.ACCOUNT.BALANCES,ERR.MSG)

    !Y.CHRG.AMT = R.LC.REC<LCAC.CHRG.ACC.AMT>
    Y.CHRG.AMT = R.LC.REC<LC.Foundation.AccountBalances.LcacChrgAccAmt>
    ! Y.CHRG.STATUS = R.LC.REC<LCAC.CHRG.STATUS>
    Y.CHRG.STATUS = R.LC.REC<LC.Foundation.AccountBalances.LcacChrgStatus>
    Y.AMT.CNT = ''
    Y.AMT.CNT = DCOUNT(Y.CHRG.AMT,@VM)

    CONVERT VM TO FM IN Y.CHRG.AMT
    CONVERT VM TO FM IN Y.CHRG.STATUS

    Y.TOTAL = ''

    FOR Y.C=1 TO Y.AMT.CNT

        IF Y.CHRG.STATUS<Y.C> EQ '2' OR Y.CHRG.STATUS<Y.C> EQ '8' OR Y.CHRG.STATUS<Y.C> EQ '9' THEN
            Y.TOTAL = Y.TOTAL + Y.CHRG.AMT<Y.C>
        END

    NEXT Y.C

    O.DATA = Y.TOTAL


RETURN


END
