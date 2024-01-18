SUBROUTINE TF.JBL.V.GET.DEFAULT.PAD.VALUE
*-----------------------------------------------------------------------------
*Subroutine Description:  
*Subroutine Type:
*Attached To    : LD.LOANS.AND.DEPOSITS Version (LD.LOANS.AND.DEPOSITS,JBL.DISB.LTR)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING AC.AccountOpening
    $USING LD.Contract
    $INSERT I_ENQUIRY.COMMON
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------  
    IF EB.SystemTables.getComi() NE "" THEN
        GOSUB INITIALISE ; *INITIALISATION
	    GOSUB OPENFILE ; *FILE OPEN
	    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    END
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LD = 'F.LD.LOANS.AND.DEPOSITS'
    F.LD = ''
    R.LD.REC = ''
    Y.LD.ERR = ''
    

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    

    Y.AC.ID = ''
    R.AC.REC = ''
    Y.AC.ERR = ''

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    

    Y.LD.CUS.ID = ''
    R.CUS.REC = ''
    Y.CUS.ERR = ''
    Y.AC.CNT = ''
    Y.SETTLE.AC.CATEG = '1979'
    Y.CUS.AC.ID = ''
    Y.AC.CATEG = ''
    Y.FLAG = ''
    Y.SETT.AC = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LD,F.LD)
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    EB.DataAccess.Opf(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    IF Y.AC.ID THEN
        GOSUB GET.LOC.REF.POS
        Y.AC.ID = EB.SystemTables.getComi()

!S - Ayush - 20131005

        Y.LD.CUS.ID = EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.CustomerId)
        EB.DataAccess.FRead(FN.CUSTOMER.ACCOUNT,Y.LD.CUS.ID,R.CUS.REC,F.CUSTOMER.ACCOUNT,Y.CUS.ERR)
        Y.AC.CNT = DCOUNT(R.CUS.REC,VM)

        FOR I = 1 TO Y.AC.CNT
            Y.CUS.AC.ID = R.CUS.REC<I,1>
            EB.DataAccess.FRead(FN.ACCOUNT,Y.CUS.AC.ID,R.AC.REC,F.ACCOUNT,Y.AC.ERR)
            Y.AC.CATEG = R.AC.REC<AC.AccountOpening.Account.Category>
            IF NOT(Y.FLAG) AND Y.AC.CATEG EQ Y.SETTLE.AC.CATEG THEN
                Y.FLAG = 'Y'
                Y.SETT.AC = Y.CUS.AC.ID
            END
        NEXT I
        R.AC.REC = ''
        Y.AC.ERR = ''
!E
        EB.DataAccess.FRead(FN.ACCOUNT,Y.AC.ID,R.AC.REC,F.ACCOUNT,Y.AC.ERR)
        Y.TOT.PAD.AMT = ABS(R.AC.REC<AC.AccountOpening.Account.WorkingBalance>)
        Y.PAD.TFNO = R.AC.REC<AC.AccountOpening.Account.LocalRef,Y.AC.TFNO.POS>
        Y.PAD.LCNO = R.AC.REC<AC.AccountOpening.Account.LocalRef,Y.AC.LCNO.POS>
        GOSUB SET.PAD.DEF.VALUE.LD
    END
RETURN
*** </region>

*** <region name= SET.PAD.DEF.VALUE.LD>
SET.PAD.DEF.VALUE.LD:
*** <desc>SET.PAD.DEF.VALUE.LD </desc>
!R.NEW(LD.CUSTOMER.ID) = Y.PAD.CUSNO

!S - Ayush - 20131005

!R.NEW(LD.DRAWDOWN.ACCOUNT) = Y.AC.ID
    IF EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.DrawdownAccount) EQ '' THEN
        EB.SystemTables.setRNew(LD.Contract.LoansAndDeposits.DrawdownAccount, Y.SETT.AC)
    END

!E
    IF EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.LocalRef)<1,Y.LD.PADAMT.POS> EQ "" THEN
        Y.TEMP = EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.LocalRef)
        Y.TEMP<1,Y.LD.PADAMT.POS> = Y.TOT.PAD.AMT
        EB.SystemTables.setRNew(LD.Contract.LoansAndDeposits.LocalRef, Y.TEMP)
    END
    IF EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.LocalRef)<1,Y.LD.LCNO.POS> EQ "" THEN
        Y.TEMP = EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.LocalRef)
        Y.TEMP<1,Y.LD.LCNO.POS> = Y.PAD.LCNO
        EB.SystemTables.setRNew(LD.Contract.LoansAndDeposits.LocalRef, Y.TEMP)
    END
    IF EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.LocalRef)<1,Y.LD.TFNO.POS> EQ "" THEN
        Y.TEMP = EB.SystemTables.getRNew(LD.Contract.LoansAndDeposits.LocalRef)
        Y.TEMP<1,Y.LD.TFNO.POS> = Y.PAD.TFNO
        EB.SystemTables.setRNew(LD.Contract.LoansAndDeposits.LocalRef, Y.TEMP)
    END
    

    RETURN
*** </region>

*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    EB.LocalReferences.GetLocRef('LD.LOANS.AND.DEPOSITS','LT.LN.IMP.PADRF',Y.LD.PADREF.POS)
    EB.LocalReferences.GetLocRef('LD.LOANS.AND.DEPOSITS','LT.LN.IMP.PADAM',Y.LD.PADAMT.POS)
    EB.LocalReferences.GetLocRef('LD.LOANS.AND.DEPOSITS','LT.TFDR.LC.NO',Y.LD.LCNO.POS)
    EB.LocalReferences.GetLocRef('LD.LOANS.AND.DEPOSITS','LT.AC.LINK.TFNO',Y.LD.TFNO.POS)
    EB.LocalReferences.GetLocRef('LD.LOANS.AND.DEPOSITS','LINKED.TFDR.REF',Y.LD.DRNO.POS)
    EB.LocalReferences.GetLocRef('ACCOUNT','LT.AC.BD.EXLCNO',Y.AC.LCNO.POS)
    EB.LocalReferences.GetLocRef('ACCOUNT','BD.DR.PUR.REFNO',Y.AC.TFNO.POS)
    RETURN
END

