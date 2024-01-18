**************************************************************************
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE JBL.V.INP.CHK.EXP.MD
**************************************************************************
*Subroutine Description:
*-----------------------
*  PURPOST:The Routine is used to check whether the local reference fields
* Reason for exemption and Exempted amount has been input when Exception
* is set to 'YES'
*-------------------------------------------------------------------------
*Parameter Description
*--------- -----------
*
* <parameter description if used>
*
*-------------------------------------------------------------------------
*Common Variable Description
*------  ------- -----------
*
*Variable name:   Insert file:          Description:
* TODAY            I_COMMON              Will hold Todays date used for
*                                        writing in flat file
*
*-------------------------------------------------------------------------
*Called Subroutines:
*------ ------------
*Routine Name:             Local/Core:     Description:
* MULTI.GET.LOC.REF        Core
*
*<Description of the arguments>
*-------------------------------------------------------------------------
* Modification History:
* ------------ --------
* 27/01/2011 -                            New   - SRIDHAR PRASAD
*                                                 Thesys Technologies
**************************************************************************
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_F.MD.DEAL



    FN.MD.DEAL = 'F.MD.DEAL'
    FV.MD.DEAL = ''
    CALL OPF(FN.MD.DEAL,FV.MD.DEAL)

    Y.APPL.NAME = 'MD.DEAL'
    Y.FLD.LIST = 'EXCEPTION':VM:'EXP.REASON':VM:'EXMD.AMT'
    Y.FLD.POS = ''

    CALL MULTI.GET.LOC.REF(Y.APPL.NAME,Y.FLD.LIST,Y.FLD.POS)
    Y.EXEMPTION.POS = Y.FLD.POS<1,1>
    Y.EXEMPTION.REASON.POS = Y.FLD.POS<1,2>
    Y.EXEMPTION.AMOUNT.POS = Y.FLD.POS<1,3>

    Y.EXEMPTION = R.NEW(MD.DEA.LOCAL.REF)<1,Y.EXEMPTION.POS>
    IF Y.EXEMPTION EQ "YES" THEN
        IF R.NEW(MD.DEA.LOCAL.REF)<1,Y.EXEMPTION.REASON.POS> EQ '' THEN
            AF = MD.DEA.LOCAL.REF
            AV = Y.EXEMPTION.REASON.POS
            ETEXT = 'EB-EXCEPTION.REASON.MISSING'
            CALL STORE.END.ERROR
        END
        IF R.NEW(MD.DEA.LOCAL.REF)<1,Y.EXEMPTION.AMOUNT.POS> EQ '' THEN
            AF = MD.DEA.LOCAL.REF
            AV = Y.EXEMPTION.AMOUNT.POS
            ETEXT = 'EB-EXEMPTION.AMT.MISSING'
            CALL STORE.END.ERROR
        END
    END

    RETURN
END
