*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>70</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE BD.V.SHIP.LC.REF.MD
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
    $INCLUDE GLOBUS.BP I_F.ACCOUNT
    $INCLUDE GLOBUS.BP I_F.LC.TYPES
    $INCLUDE GLOBUS.BP I_F.MD.DEAL
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

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)
    R.AC.REC = ''

    FN.LC.TYPES = 'F.LC.TYPES'
    F.LC.TYPES = ''
    CALL OPF(FN.LC.TYPES,F.LC.TYPES)
    R.LC.TYPES = ''
    Y.LC.TYPES.ERR = ''

    FN.MD = 'F.MD.DEAL'
    F.MD = ''
    CALL OPF(FN.MD,F.MD)
    R.MD.REC = ''
    Y.MD.ERR = ''


    RETURN
*-----------------------------------------------------------------------------
PROCESS:
********
    GOSUB GET.LOC.REF.POS
    Y.LC.REF.NO = COMI
    CALL F.READ(FN.LETTER.OF.CREDIT,Y.LC.REF.NO,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.LETTER.OF.CREDIT.ERR)
    IF R.LETTER.OF.CREDIT EQ '' THEN RETURN

    Y.BB.LC.NO = R.LETTER.OF.CREDIT<TF.LC.OLD.LC.NUMBER>
    Y.LC.LCAFNO = R.LETTER.OF.CREDIT<TF.LC.LOCAL.REF,Y.LC.LCAFNO.POS>
    Y.LC.MDNO = R.LETTER.OF.CREDIT<TF.LC.LOCAL.REF,Y.LC.MDNO.POS>
    Y.LC.TYPE = R.LETTER.OF.CREDIT<TF.LC.LC.TYPE>
    CALL F.READ(FN.LC.TYPES,Y.LC.TYPE,R.LC.TYPES,F.LC.TYPES,Y.LC.TYPES.ERR)
    Y.LC.IMP.EXP = R.LC.TYPES<LC.TYP.IMPORT.EXPORT>
    IF Y.LC.MDNO NE '' THEN
        AF = MD.DEA.LOCAL.REF
        AV = Y.MD.TFNO.POS
        ETEXT ="Already Issued Shipping Guarantee"
        CALL STORE.END.ERROR
    END

    IF Y.LC.IMP.EXP EQ 'I' THEN
        R.NEW(MD.DEA.LOCAL.REF)<1,Y.MD.BBLCNO.POS> = Y.BB.LC.NO
        R.NEW(MD.DEA.LOCAL.REF)<1,Y.MD.LCAFNO.POS> = Y.LC.LCAFNO
        R.NEW(MD.DEA.CUSTOMER) = R.LETTER.OF.CREDIT<TF.LC.APPLICANT.CUSTNO>
        R.NEW(MD.DEA.CURRENCY) = R.LETTER.OF.CREDIT<TF.LC.LC.CURRENCY>
        R.NEW(MD.DEA.BENEF.CUST.1) = R.LETTER.OF.CREDIT<TF.LC.BENEFICIARY.CUSTNO>
        R.NEW(MD.DEA.MATURITY.DATE) = R.LETTER.OF.CREDIT<TF.LC.EXPIRY.DATE>
        R.NEW(MD.DEA.LOCAL.REF)<1,Y.MD.BENNAM.POS> = EREPLACE(R.LETTER.OF.CREDIT<TF.LC.BENEFICIARY>,VM,SM)
        CALL REBUILD.SCREEN
    END ELSE
        ETEXT ="Not Allow For Shipping Guarantee"
        CALL STORE.END.ERROR
    END

    RETURN
*-----------------------------------------------------------------------------
GET.LOC.REF.POS:
*--------------
    CALL GET.LOC.REF('MD.DEAL','LINKED.TF.NO',Y.MD.TFNO.POS)
    CALL GET.LOC.REF('MD.DEAL','LC.NO',Y.MD.BBLCNO.POS)
    CALL GET.LOC.REF('MD.DEAL','LCAF.NO',Y.MD.LCAFNO.POS)
    CALL GET.LOC.REF('MD.DEAL','IMPORTER.NAME',Y.MD.BENNAM.POS)
    CALL GET.LOC.REF('LETTER.OF.CREDIT','LCAF.NO',Y.LC.LCAFNO.POS)
    CALL GET.LOC.REF('LETTER.OF.CREDIT','MD.GTEE.ID',Y.LC.MDNO.POS)
    RETURN
END
