
SUBROUTINE GB.JBL.CR.TTV.CKID

*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: VERSION - EB.JBL.TT.VAULT,INPUT
* Attach As: Check Record ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTV.CKID
* 18/09/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
*
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $INSERT I_F.EB.JBL.TT.VAULT
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING ST.CompanyCreation
    $USING TT.Config
    
    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()

    IF Y.ID.NEW NE Y.ID.COMPANY[6,4]:'.':Y.TODAY THEN
        RL.ID = 'F.EB.JBL.TT.VAULT$NAU':'.':Y.ID.NEW
        FN.RL = 'F.RECORD.LOCK'
        F.RL = ''
        EB.DataAccess.Opf(FN.RL,F.RL)
        EB.DataAccess.FRead(FN.RL,RL.ID,R.RL,F.RL,ERR.RL)
        DELETE F.RL,RL.ID SETTING RL.CONF
        
* ID.NEW = ID.COMPANY[6,4]:'.':TODAY
        Y.ID.NEW = Y.ID.COMPANY[6,4]:'.':Y.TODAY
        EB.SystemTables.setIdNew(Y.ID.NEW)
    END
    
    IF (Y.ID.COMPANY[1,5] NE 'BD001') AND (Y.ID.COMPANY EQ 'BD0015051') AND (Y.ID.COMPANY EQ 'BD0019999') THEN
        RETURN
    END
    
    FN.V = 'F.EB.JBL.TT.VAULT$NAU'
    F.V = ''
    FN.VA = 'F.EB.JBL.TT.VAULT'
    F.VA = ''
    FN.CO = 'F.COMPANY'
    F.CO = ''
    FN.D = 'F.TELLER.DENOMINATION'
    F.D = ''
    EB.DataAccess.Opf(FN.D,F.D)
    EB.DataAccess.Opf(FN.CO,F.CO)
    EB.DataAccess.Opf(FN.V,F.V)
    EB.DataAccess.Opf(FN.VA,F.VA)
    
* R.NEW(TTV.RECORD.STATUS)
    Y.TTV.REC.STATUS = EB.SystemTables.getRNew(EB.TT.83.RECORD.STATUS)
    
    IF Y.TTV.REC.STATUS EQ '' THEN
        EB.DataAccess.FRead(FN.VA, Y.ID.NEW, R.CK, F.VA, ERR.CK)
        
        IF R.CK EQ '' THEN
            EB.DataAccess.FRead(FN.CO, 'BD001':Y.ID.NEW[1,4], R.CO, F.CO, ERR.CO)
* R.NEW(EB.TT.83.BR.INFO) = Y.ID.NEW[1,4]:' ':R.CO<ST.CompanyCreation.Company.EbComCompanyName>
            Y.ID.BR.INFO = Y.ID.NEW[1,4]:' ':R.CO<ST.CompanyCreation.Company.EbComCompanyName>
            EB.SystemTables.setRNew(EB.TT.83.BR.INFO, Y.ID.BR.INFO)
            
            SEL.CMD = 'SELECT ':FN.D:' BY-DSND VALUE WITH @ID LIKE BDT...'
            EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, F.D, NO.OF.REC, D.CODE)
            FOR II = 1 TO NO.OF.REC
* R.NEW(TTV.DENOM)<1,II>= SEL.LIST<I>
                Y.GET.TT.DENOM = EB.SystemTables.getRNew(EB.TT.83.DENOM)
                Y.TT.DENOM = Y.GET.TT.DENOM<1,II>
                EB.SystemTables.setRNew(Y.TT.DENOM, SEL.LIST<II>)
* R.NEW(TTV.F.UNIT)<1,II> = 0
                Y.GET.TT.F.UNIT = EB.SystemTables.getRNew(EB.TT.83.F.UNIT)
                Y.TT.F.UNIT = Y.GET.TT.F.UNIT<1,II>
                EB.SystemTables.setRNew(Y.TT.F.UNIT, 0)
* R.NEW(TTV.M.UNIT)<1,II> = 0
                Y.GET.TT.M.UNIT = EB.SystemTables.getRNew(EB.TT.83.M.UNIT)
                Y.TT.M.UNIT = Y.GET.TT.M.UNIT<1,II>
                EB.SystemTables.setRNew(Y.TT.M.UNIT, 0)
* R.NEW(TTV.N.UNIT)<1,II> = 0
                Y.GET.TT.N.UNIT = EB.SystemTables.getRNew(EB.TT.83.N.UNIT)
                Y.TT.N.UNIT = Y.GET.TT.N.UNIT<1,II>
                EB.SystemTables.setRNew(Y.TT.N.UNIT, 0)
* R.NEW(TTV.COIN)<1,II> = 0
                Y.GET.TT.COIN = EB.SystemTables.getRNew(EB.TT.83.COIN)
                Y.TT.COIN = Y.GET.TT.COIN<1,II>
                EB.SystemTables.setRNew(Y.TT.COIN, 0)
            NEXT II
        
*            R.NEW(TTV.TXN.DATE) = Y.ID.NEW[6,8]
            EB.SystemTables.setRNew(EB.TT.83.TXN.DATE, Y.ID.NEW[6,8])
*            R.NEW(TTV.T.M.UNIT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.M.UNIT, 0)
*            R.NEW(TTV.T.F.UNIT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.F.UNIT, 0)
*            R.NEW(TTV.T.N.UNIT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.N.UNIT, 0)
*            R.NEW(TTV.T.COIN) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.COIN, 0)
*            R.NEW(TTV.T.M.AMT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.M.AMT, 0)
*            R.NEW(TTV.T.F.AMT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.F.AMT, 0)
*            R.NEW(TTV.T.N.AMT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.N.AMT, 0)
*            R.NEW(TTV.T.C.AMT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.C.AMT, 0)
*            R.NEW(TTV.T.AMT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.AMT, 0)
*            R.NEW(TTV.T.AMT.W) = ''
            EB.SystemTables.setRNew(EB.TT.83.T.AMT.W, 0)
*            R.NEW(TTV.T.UNIT) = 0
            EB.SystemTables.setRNew(EB.TT.83.T.UNIT, 0)
        END
        ELSE
            GOSUB OLD_ENTRY
            RETURN
        END
    END
    EB.DataAccess.FRead(FN.V, Y.ID.NEW, R.CK, F.V, ERR.CK)
    Y.REC.STATUS = R.CK<EB.TT.83.RECORD.STATUS>
    IF Y.REC.STATUS EQ 'INAU' THEN
        GOSUB OLD_ENTRY
    END
RETURN

OLD_ENTRY:
*    R.NEW(TTV.DENOM) = R.CK<TTV.DENOM>
    Y.TTV.DENOM = R.CK<EB.TT.83.DENOM>
    EB.SystemTables.setRNew(EB.TT.83.DENOM, Y.TTV.DENOM)
*    R.NEW(TTV.F.UNIT) = R.CK<TTV.F.UNIT>
    Y.TTV.F.UNIT = R.CK<EB.TT.83.F.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.F.UNIT, Y.TTV.F.UNIT)
*    R.NEW(TTV.M.UNIT) = R.CK<TTV.M.UNIT>
    Y.TTV.M.UNIT = R.CK<EB.TT.83.M.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.M.UNIT, Y.TTV.M.UNIT)
*    R.NEW(TTV.N.UNIT) = R.CK<TTV.N.UNIT>
    Y.TTV.N.UNIT = R.CK<EB.TT.83.N.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.N.UNIT, Y.TTV.N.UNIT)
*    R.NEW(TTV.COIN) = R.CK<TTV.COIN>
    Y.TTV.COIN = R.CK<EB.TT.83.COIN>
    EB.SystemTables.setRNew(EB.TT.83.COIN, Y.TTV.COIN)
*    R.NEW(TTV.BR.INFO) = R.CK<TTV.BR.INFO>
    Y.TTV.BR.INFO = R.CK<EB.TT.83.BR.INFO>
    EB.SystemTables.setRNew(EB.TT.83.BR.INFO, Y.TTV.BR.INFO)
*    R.NEW(TTV.TXN.DATE) = R.CK<TTV.TXN.DATE>
    Y.TTV.TXN.DATE = R.CK<EB.TT.83.TXN.DATE>
    EB.SystemTables.setRNew(EB.TT.83.TXN.DATE, Y.TTV.TXN.DATE)
*    R.NEW(TTV.T.M.UNIT) = R.CK<TTV.T.M.UNIT>
    Y.TTV.T.M.UNIT = R.CK<EB.TT.83.T.M.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.T.M.UNIT, Y.TTV.T.M.UNIT)
*    R.NEW(TTV.T.F.UNIT) = R.CK<TTV.T.F.UNIT>
    Y.TTV.T.F.UNIT = R.CK<EB.TT.83.T.F.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.T.F.UNIT, Y.TTV.T.F.UNIT)
*    R.NEW(TTV.T.N.UNIT) = R.CK<TTV.T.N.UNIT>
    Y.TTV.T.N.UNIT = R.CK<EB.TT.83.T.N.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.T.N.UNIT, Y.TTV.T.N.UNIT)
*    R.NEW(TTV.T.COIN) = R.CK<TTV.T.COIN>
    Y.TTV.T.COIN = R.CK<EB.TT.83.T.COIN>
    EB.SystemTables.setRNew(EB.TT.83.T.COIN, Y.TTV.T.COIN)
*    R.NEW(TTV.T.M.AMT) = R.CK<TTV.T.M.AMT>
    Y.TTV.T.M.AMT = R.CK<EB.TT.83.T.M.AMT>
    EB.SystemTables.setRNew(EB.TT.83.T.M.AMT, Y.TTV.T.M.AMT)
*    R.NEW(TTV.T.F.AMT) = R.CK<TTV.T.F.AMT>
    Y.TTV.T.F.AMT = R.CK<EB.TT.83.T.F.AMT>
    EB.SystemTables.setRNew(EB.TT.83.T.M.AMT, Y.TTV.T.F.AMT)
*    R.NEW(TTV.T.N.AMT) = R.CK<TTV.T.N.AMT>
    Y.TTV.T.N.AMT = R.CK<EB.TT.83.T.N.AMT>
    EB.SystemTables.setRNew(EB.TT.83.T.N.AMT, Y.TTV.T.N.AMT)
*    R.NEW(TTV.T.C.AMT) = R.CK<TTV.T.C.AMT>
    Y.TTV.T.C.AMT = R.CK<EB.TT.83.T.C.AMT>
    EB.SystemTables.setRNew(EB.TT.83.T.C.AMT, Y.TTV.T.C.AMT)
*    R.NEW(TTV.T.AMT) = R.CK<TTV.T.AMT>
    Y.TTV.T.AMT = R.CK<EB.TT.83.T.AMT>
    EB.SystemTables.setRNew(EB.TT.83.T.AMT, Y.TTV.T.AMT)
*    R.NEW(TTV.T.AMT.W) = R.CK<TTV.T.AMT.W>
    Y.TTV.T.AMT.W = R.CK<EB.TT.83.T.AMT.W>
    EB.SystemTables.setRNew(EB.TT.83.T.AMT.W, Y.TTV.T.AMT.W)
*    R.NEW(TTV.T.UNIT) = R.CK<TTV.T.UNIT>
    Y.TTV.T.UNIT = R.CK<EB.TT.83.T.UNIT>
    EB.SystemTables.setRNew(EB.TT.83.T.UNIT, Y.TTV.T.UNIT)
   
RETURN
END

