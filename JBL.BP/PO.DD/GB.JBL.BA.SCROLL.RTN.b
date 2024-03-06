SUBROUTINE GB.JBL.BA.SCROLL.RTN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.EB.JBL.H.SCROLL
    $USING   FT.Contract
    $USING   TT.Contract
    $USING   EB.SystemTables
    $USING   EB.DataAccess
    $USING   EB.Updates

    IF EB.SystemTables.getVFunction() EQ 'R' OR EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus) EQ 'RNAU' OR EB.SystemTables.getRNew(TT.Contract.Teller.TeRecordStatus) EQ 'RNAU' THEN RETURN

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.SCROLL='F.EB.JBL.H.SCROLL'
    F.SCROLL=''

    Y.APP.NAME='FUNDS.TRANSFER' : FM : 'TELLER'
    Y.LOCAL.FIELDS='LT.SCROLL' : VM : 'LT.COMPANY': VM : 'LT.DD.TT.MT':FM: 'LT.SCROLL': VM : 'LT.COMPANY': VM : 'LT.DD.TT.MT'
    EB.Updates.MultiGetLocRef(Y.APP.NAME, Y.LOCAL.FIELDS, Y.FIELDS.POS)
   
    Y.SCROLL.POS.FT=Y.FIELDS.POS<1,1>
    Y.COMP.POS.FT = Y.FIELDS.POS<1,2>
    Y.TTMT.POS.FT = Y.FIELDS.POS<1,3>
    
    Y.SCROLL.POS.TT=Y.FIELDS.POS<2,1>
    Y.COMP.POS.TT = Y.FIELDS.POS<2,2>
    Y.TTMT.POS.TT = Y.FIELDS.POS<2,3>
    
    
RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.SCROLL,F.SCROLL)
RETURN

*-------
PROCESS:
*-------

    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN

        BEGIN CASE
            
            CASE EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType) EQ 'DD'
                Y.SCROLL.ID=RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.COMP.POS.TT>,4):".":EB.SystemTables.getToday()[1,4]
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT>, REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1)
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1
                    Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                ELSE
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT> , 1)
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = 1
                    Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.FT)
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

            CASE EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.TTMT.POS.TT> EQ 'TT'
                Y.SCROLL.ID=RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.COMP.POS.TT>,4):".":EB.SystemTables.getToday()[1,4]
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT> , REC.SCROLL<SC.TT.SCROLL.NO> + 1)
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1
                    Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                ELSE
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT> , 1)
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = 1
                    Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END

                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

            CASE EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.TTMT.POS.TT> EQ 'MT'
                Y.SCROLL.ID=RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.COMP.POS.TT>,4):".":EB.SystemTables.getToday()[1,4]
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT> , REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1)
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1
                    Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                ELSE
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.SCROLL.POS.TT> , 1)
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = 1
                    Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> , 1)
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

        END CASE
    END

 
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN

        BEGIN CASE
            CASE EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType) EQ 'DD'
                Y.SCROLL.ID=RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.COMP.POS.FT>,4):".":EB.SystemTables.getToday()[1,4]
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.NO=REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> =  Y.SCROLL.NO
                    Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                END
                ELSE
                    Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> , 1)
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = 1
                END
                EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> ,  Y.SCROLL.NO)
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

            CASE EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.TTMT.POS.FT> EQ 'TT'
                Y.SCROLL.ID=RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.COMP.POS.FT>,4):".":EB.SystemTables.getToday()[1,4]
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)

                IF REC.SCROLL THEN
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> , REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1)
                    Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1
                END
                ELSE
*EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> , 1)
                    Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = 1
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID
              
            CASE EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.TTMT.POS.FT> EQ 'MT'
                Y.SCROLL.ID=RIGHT(EB.SystemTables.getIdCompany(),4):".":RIGHT(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.COMP.POS.FT>,4):".":EB.SystemTables.getToday()[1,4]
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
* EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> , REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1)
                    Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1
                END
                ELSE
* EB.SystemTables.setRNew(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.SCROLL.POS.FT> , 1)
                    Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = 1
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID
             
        END CASE
    END
RETURN
END

