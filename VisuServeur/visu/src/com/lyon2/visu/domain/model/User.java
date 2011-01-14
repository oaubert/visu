/**
 * Copyright Université Lyon 1 / Université Lyon 2 (2009,2010)
 * 
 * <ithaca@liris.cnrs.fr>
 * 
 * This file is part of Visu.
 * 
 * This software is a computer program whose purpose is to provide an
 * enriched videoconference application.
 * 
 * Visu is a free software subjected to a double license.
 * You can redistribute it and/or modify since you respect the terms of either 
 * (at least one of the both license) :
 * - the GNU Lesser General Public License as published by the Free Software Foundation; 
 *   either version 3 of the License, or any later version. 
 * - the CeCILL-C as published by CeCILL; either version 2 of the License, or any later version.
 * 
 * -- GNU LGPL license
 * 
 * Visu is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 * 
 * Visu is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with Visu.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * -- CeCILL-C license
 * 
 * This software is governed by the CeCILL-C license under French law and
 * abiding by the rules of distribution of free software.  You can  use, 
 * modify and/ or redistribute the software under the terms of the CeCILL-C
 * license as circulated by CEA, CNRS and INRIA at the following URL
 * "http://www.cecill.info". 
 * 
 * As a counterpart to the access to the source code and  rights to copy,
 * modify and redistribute granted by the license, users are provided only
 * with a limited warranty  and the software's author,  the holder of the
 * economic rights,  and the successive licensors  have only  limited
 * liability. 
 * 
 * In this respect, the user's attention is drawn to the risks associated
 * with loading,  using,  modifying and/or developing or reproducing the
 * software by the user in light of its specific status of free software,
 * that may mean  that it is complicated to manipulate,  and  that  also
 * therefore means  that it is reserved for developers  and  experienced
 * professionals having in-depth computer knowledge. Users are therefore
 * encouraged to load and test the software's suitability as regards their
 * requirements in conditions enabling the security of their systems and/or 
 * data to be ensured and,  more generally, to use and operate it in the 
 * same conditions as regards security. 
 * 
 * The fact that you are presently reading this means that you have had
 * knowledge of the CeCILL-C license and that you accept its terms.
 * 
 * -- End of licenses
 */
package com.lyon2.visu.domain.model;

public class User 
{	
	public static final int OFFLINE   = 0;
    public static final int ONLINE    = 1;
    public static final int IN_A_ROOM = 2;
    public static final int RECORDING = 4;
	/**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.id_user
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private Integer id_user;
	
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.lastname
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String lastname;
	
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.firstname
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String firstname;
	
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.mail
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String mail;
	
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.password
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String password;
	
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.profil
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    private String profil;

    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.avatar
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */	
    private String avatar;

    private String message;
    /**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.activation_key
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */	
    private String activation_key;

	/**
     * This field was generated by Abator for iBATIS.
     * This field corresponds to the database column users.recovery_key
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */ 
    private String recovery_key;
    
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.id_user
     *
     * @return the value of users.id
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public Integer getId_user() {
        return id_user;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.id_user
     *
     * @param id the value for users.id
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setId_user(Integer id_user) {
        this.id_user = id_user;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.lastname
     *
     * @return the value of users.lastname
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getLastname() {
        return lastname;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.lastname
     *
     * @param lastname the value for users.lastname
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setLastname(String lastname) {
        this.lastname = lastname == null ? null : lastname.trim();
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.firstname
     *
     * @return the value of users.firstname
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getFirstname() {
        return firstname;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.firstname
     *
     * @param firstname the value for users.firstname
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setFirstname(String firstname) {
        this.firstname = firstname == null ? null : firstname.trim();
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.mail
     *
     * @return the value of users.mail
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getMail() {
        return mail;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.mail
     *
     * @param mail the value for users.mail
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setMail(String mail) {
        this.mail = mail == null ? null : mail.trim();
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.password
     *
     * @return the value of users.password
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getPassword() {
        return password;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.password
     *
     * @param password the value for users.password
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.profil
     *
     * @return the value of users.profil
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public String getProfil() {
        return profil;
    }
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.profil
     *
     * @param role the value for users.profil
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */
    public void setProfil(String profil) {
        this.profil = profil;
    }
		
    /**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.activation_key
     *
     * @return the value of users.activation_key
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */	
	public String getActivation_key() {
		return activation_key;
	}
	
    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.activation_key
     *
     * @param groupe_id the value for users.activation_key
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */	
	public void setActivation_key(String activation_key) {
		this.activation_key = activation_key;
	}

	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.recovery_key
     *
     * @return the value of users.recovery_key
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */	
	public String getRecovery_key() {
		return recovery_key;
	}

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.recovery_key
     *
     * @param groupe_id the value for users.recovery_key
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */		
	public void setRecovery_key(String recovery_key) {
		this.recovery_key = recovery_key;
	}
	
	/**
     * This method was generated by Abator for iBATIS.
     * This method returns the value of the database column users.avatar
     *
     * @return the value of users.avatar
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */		
	public String getAvatar() {
		return avatar;
	}

    /**
     * This method was generated by Abator for iBATIS.
     * This method sets the value of the database column users.avatar
     *
     * @param groupe_id the value for users.avatar
     *
     * @abatorgenerated Thu May 28 10:17:15 CEST 2009
     */		
	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}
	
	public String getMessage() {
		return message;
	}
	
	public void setMessage(String value) {
		this.message = value;
	}
    /**
     * toString will return String object representing the state of this 
     * valueObject. This is useful during application development, and 
     * possibly when application is writing object states in textlog.
     */
    public String toString() 
    {
        StringBuffer out = new StringBuffer("class User {");
        out.append("id_user = " + this.id_user + ", ");
        out.append("lastname = " + this.lastname + ", ");
        out.append("firstname = " + this.firstname + "}");
        out.append("message = " + this.message + "}");
        return out.toString();
    }    
}
