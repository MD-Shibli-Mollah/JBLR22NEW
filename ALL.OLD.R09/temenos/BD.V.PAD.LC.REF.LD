*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>69</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE BD.V.PAD.LC.REF.LD
*-----------------------------------------------------------------------------
* Subroutine Description:
*------------------------
* This routine is fatch record from LC FOR Populate Value in PAD
*-----------------------------------------------------------------------------
* Modification History:
* ---------------------
* 20/04/2012 - New - Rayhan
*
*-----------------------------------------------------------------------------
    $INCLUDE GLOBUS.BP I_COMMON
    $INCLUDE GLOBUS.BP I_EQUATE
    $INCLUDE GLOBUS.BP I_F.LETTER.OF.CREDIT
    $INCLUDE GLOBUS.BP I_F.LD.LOANS.AND.DEPOSITS
    $INCLUDE GLOBUS.BP I_F.LC.TYPES
    $INSERT I_F.DRAWINGS
    $INSERT I_F.BD.BTB.JOB.REGISTER

    GOSUB INITIALISE
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INITIALISE:
***********

    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    F.LETTER.OF.CREDIT  = ''
    CALL OPF(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    R.LETTER.OF.CREDIT  = ''

    FN.LD.LOANS.AND.DEPOSITS = 'F.LD.LOANS.AND.DEPOSITS'
    F.LD.LOANS.AND.DEPOSITS  = ''
    CALL OPF(FN.LD.LOANS.AND.DEPOSITS,F.LD.LOANS.AND.DEPOSITS)
    R.LD.LOANS.AND.DEPOSITS  = ''


    FN.LC.TYPES = 'F.LC.TYPES'
    F.LC.TYPES = ''
    CALL OPF(FN.LC.TYPES,F.LC.TYPES)
    R.LC.TYPES = ''
    Y.LC.TYPES.ERR = ''


    RETURN
*-----------------------------------------------------------------------------
PROCESS:
********
    GOSUB GET.LOC.REF.POS
!Y.DR.ID = COMI
    Y.LC.REF.NO = COMI
    CALL F.READ(FN.LETTER.OF.CREDIT,Y.LC.REF.NO,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.LETTER.OF.CREDIT.ERR)
    IF R.LETTER.OF.CREDIT EQ '' THEN RETURN

    Y.BB.LC.NO = R.LETTER.OF.CREDIT<TF.LC.OLD.LC.NUMBER>
    Y.CUSTO = R.LETTER.OF.CREDIT<TF.LC.APPLICANT.CUSTNO>
    Y.LC.TYPE = R.LETTER.OF.CREDIT<TF.LC.LC.TYPE>
    CALL F.READ(FN.LC.TYPES,Y.LC.TYPE,R.LC.TYPES,F.LC.TYPES,Y.LC.TYPES.ERR)
    Y.LC.IMP.EXP = R.LC.TYPES<LC.TYP.IMPORT.EXPORT>
    IF Y.LC.IMP.EXP EQ 'I' THEN
        Y.LC.CCY = R.LETTER.OF.CREDIT<TF.LC.LC.CURRENCY>
        Y.LC.AMT = R.LETTER.OF.CREDIT<TF.LC.LC.AMOUNT>
        Y.LC.AMOUNT = Y.LC.CCY : Y.LC.AMT

        R.NEW(LD.LOCAL.REF)<1,Y.LD.BBLCNO.POS> = Y.BB.LC.NO
        R.NEW(LD.LOCAL.REF)<1,Y.LD.LCAMT.POS> = Y.LC.AMOUNT
        R.NEW(LD.CUSTOMER.ID) = Y.CUSTO
        CALL REBUILD.SCREEN
    END ELSE
        ETEXT ="THIS LC NOT ALLOW FOR PAD CREATION"
        CALL STORE.END.ERROR
    END

    RETURN
*-----------------------------------------------------------------------------
GET.LOC.REF.POS:
*--------------
    CALL GET.LOC.REF('LD.LOANS.AND.DEPOSITS','LINKED.TF.NO',Y.LD.TFNO.POS)
    CALL GET.LOC.REF('LD.LOANS.AND.DEPOSITS','LC.NO',Y.LD.BBLCNO.POS)
    CALL GET.LOC.REF('LD.LOANS.AND.DEPOSITS','LC.AMOUNT',Y.LD.LCAMT.POS)

    RETURN
END
